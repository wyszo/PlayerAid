//
//  PlayerAid
//

@import KZAsserts;
@import QuartzCore;
@import AFNetworking;
@import DateTools;
@import TWCommonLib;
#import "TutorialTableViewCell.h"
#import "UIImageView+AvatarStyling.h"
#import "User.h"
#import "Section.h"
#import "TutorialCellHelper.h"
#import "SectionLabelContainer.h"
#import "ColorsHelper.h"
#import "PlayerAid-Swift.h"

static const NSTimeInterval kImageRequestTimeoutIntervalSeconds = 10.0f;
static const NSTimeInterval kBackgroundImageViewFadeInDuration = 0.2f;


@interface TutorialTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet SectionLabelContainer *sectionLabelContainer;
@property (weak, nonatomic) IBOutlet UIView *sectionTitleBackground;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@property (weak, nonatomic) IBOutlet UIView *plainOverlayView;

// TODO: move those two into a separate class
@property (weak, nonatomic) IBOutlet UIView *gradientOverlayView;
@property (weak, nonatomic) IBOutlet TWGradientView *topGradientOverlayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomGapHeightConstraint;

@property (weak, nonatomic) Tutorial *tutorial;
@property (weak, nonatomic) IBOutlet TutorialCellOverlay *overlayView;

@end


@implementation TutorialTableViewCell

#pragma mark - Cell setup & skinning

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  if ([self respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
    self.preservesSuperviewLayoutMargins = NO;
  }
  
  [self.avatarImageView styleAsSmallAvatar];
  [self setupGradient];
  [self showGradientOverlay:YES];
}

- (void)setupGradient
{
  UIColor *halfTransparentBlack = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
  self.topGradientOverlayView.gradientColors = @[[UIColor clearColor], halfTransparentBlack];
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  self.avatarImageView.image = nil;
  self.backgroundImageView.image = nil;
  [self.avatarImageView cancelImageRequestOperation];
  [self.backgroundImageView cancelImageRequestOperation];
  [self setSectionNameHidden:NO];
  [self showGradientOverlay:YES];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if (self.canBeDeletedOnSwipe && self.showingDeleteConfirmation) {
    [self customiseDeleteButtonHeight];
  }
}

- (void)customiseDeleteButtonHeight
{
  if (!self.showBottomGap) {
    return;
  }
  
  for (UIView *subview in self.subviews) {
    if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
      UIView *deleteButtonView = subview;
      CGRect frame = deleteButtonView.frame;
      CGFloat bottomGapHeight = [TutorialCellHelper new].bottomGapHeight;
      frame.size.height = self.frame.size.height - bottomGapHeight;
      deleteButtonView.frame = frame;
    }
  }
  // TODO: this approach sucks - gaps between tableView cells are implemented as part of cells, instead of dummy sections. That's why we traverse view hierarchy to decrease size of a delete button. Likely to break in future iOS versions.
}

- (void)setSectionNameHidden:(BOOL)hidden
{
  self.sectionTitleBackground.hidden = hidden;
  self.sectionLabelContainer.hidden = hidden;
}

#pragma mark - Public methods

- (void)configureWithTutorial:(Tutorial *)tutorial
{
  self.tutorial = tutorial;
  
  TutorialCellViewModel *viewModel = [[TutorialCellViewModel alloc] initWithTutorial: tutorial];
  [self configureWithViewModel: viewModel];
  
  [self updateBackgroundImageView];
  [self updateLikeButtonState];
  self.titleLabel.text = tutorial.title;
  self.authorLabel.text = tutorial.createdBy.name;
  self.sectionLabelContainer.titleLabel.text = tutorial.section.displayName;
  [self setSectionNameHidden:(self.tutorial.section == nil)];
  
  self.timeLabel.text = viewModel.timeAgo;
  
  [tutorial.createdBy placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSizeMedium];
  // TODO: update favourited button state based on User's liked relation
}

- (void)updateLikeButtonState
{
  BOOL likeButtonVisible = (self.tutorial.isPublished);
  self.favouriteButton.hidden = !likeButtonVisible;
  [self setFavouritedButtonState:self.likeButtonHighlighted];
}

- (void)showGradientOverlay:(BOOL)showGradientOverlay
{
  self.plainOverlayView.hidden = showGradientOverlay;
  
  self.gradientOverlayView.hidden = !(showGradientOverlay);
  self.topGradientOverlayView.hidden = (!showGradientOverlay);
}

- (void)configureWithViewModel:(TutorialCellViewModel *)viewModel {
    AssertTrueOrReturn(viewModel);
    
    self.overlayView.text = viewModel.cellOverlayLabelText;
    [self.overlayView setLabelBackgroundColor:viewModel.cellOverlayLabelBackground];
    [self.overlayView setOverlayBackgroundColor:viewModel.cellOverlayBackground];
    [self.overlayView setOverlayBackgroundAlpha:viewModel.cellOverlayAlpha];
    
    self.overlayView.hidden = viewModel.overlayHidden;
}

#pragma mark - Update UI to match Tutorial

- (void)updateBackgroundImageView
{
  if ((self.tutorial.jpegImageData && !self.tutorial.isPublished) || self.tutorial.isDraft) {
    [self updateBackgroundImageViewFromTutorialData];
  }
  else {
    [self fetchBackgroundImageView];
  }
}

- (void)updateBackgroundImageViewFromTutorialData
{
  if (!self.tutorial.isDraft) { // drafts are not required to contain imageData
    AssertTrueOrReturn(self.tutorial.jpegImageData);
  }
  self.backgroundImageView.image = [UIImage imageWithData:self.tutorial.jpegImageData];
}

- (void)fetchBackgroundImageView
{
  NSString *imageURLString = self.tutorial.imageURL;
  AssertTrueOrReturn(imageURLString.length);
  
  NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tutorial.imageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:kImageRequestTimeoutIntervalSeconds];
  
  // we want to display images from cache without fadeIn animation
  BOOL imageCachedOnDisk = ([[NSURLCache sharedURLCache] tw_cachedHTTPResponseForURLRequest:imageURLRequest] != nil);
  
  defineWeakSelf();
  [self.backgroundImageView setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    defineStrongSelf();
    
    BOOL imageFromAFNetworkingInMemoryCache = (request == nil && response == nil && image != nil);
    // Right now there's a visible lag for images from a disk cache - but it'll go away once timeline images prefetching is implemented
    
    if (imageCachedOnDisk || imageFromAFNetworkingInMemoryCache) {
      [strongSelf setBackgroundImage:image fadeInAnimation:NO];
    }
    else {
      [strongSelf setBackgroundImage:image fadeInAnimation:YES];
    }
  } failure:nil];
}

- (BOOL)likeButtonHighlighted
{
  return (self.tutorial.isPublished && self.loggedInUserLikesTutorial);
}

- (BOOL)loggedInUserLikesTutorial
{
  // we should check currentUser's createdTutorial relationship instead! 
  __block BOOL likesTutorial = NO;
  
  [self.tutorial.likedBy enumerateObjectsUsingBlock:^(User *user, BOOL *stop) {
    if (user.loggedInUserValue) {
      likesTutorial = YES;
      *stop = YES;
    }
  }];
  return likesTutorial;
}

#pragma mark - Other methods

- (void)setShowBottomGap:(BOOL)showBottomGap
{
  _showBottomGap = showBottomGap;
  CGFloat bottomGapHeight = [TutorialCellHelper new].bottomGapHeight;
  self.bottomGapHeightConstraint.constant = (showBottomGap ? bottomGapHeight : 0.0f);
}

#pragma mark - Auxiliary methods

- (void)setBackgroundImage:(nonnull UIImage *)image fadeInAnimation:(BOOL)fadeInAnimation
{
  if (!fadeInAnimation) {
    self.backgroundImageView.image = image;
    self.backgroundImageView.alpha = 1.0f;
  } else {
    self.backgroundImageView.alpha = 0.0f;
    self.backgroundImageView.image = image;
    [UIView animateWithDuration:kBackgroundImageViewFadeInDuration animations:^{
      self.backgroundImageView.alpha = 1.0f;
    }];
  }
}

- (void)setFavouritedButtonState:(BOOL)favourited
{
  NSString *imageName = @"";
  if (favourited) {
    imageName = @"like_button_pressed";
  } else {
    imageName = @"like_button_unpressed";
  }
  [self.favouriteButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark - IBActions

- (IBAction)favouriteButtonPressed:(id)sender
{
  AssertTrueOrReturn(self.tutorial);
  BOOL newState = !self.likeButtonHighlighted;
  CallBlock(self.tutorialFavouritedBlock, newState, self);
}

- (IBAction)authorButtonPressed:(id)sender
{
  if (self.userAvatarOrNameSelectedBlock) {
    self.userAvatarOrNameSelectedBlock(self.tutorial.createdBy);
  }
}

@end
