//
//  PlayerAid
//

#import "TutorialTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+AFNetworking.h>
#import <NSDate+TimeAgo.h>
#import "UIImageView+AvatarStyling.h"
#import "User.h"
#import "Section.h"
#import "TutorialCellHelper.h"
#import "GradientHelper.h"
#import "SectionLabelContainer.h"


static const NSTimeInterval kBackgroundImageViewFadeInDuration = 0.3f;


@interface TutorialTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet SectionLabelContainer *sectionLabelContainer;
@property (weak, nonatomic) IBOutlet UIView *sectionTitleBackground;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIView *gradientOverlayView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (weak, nonatomic) Tutorial *tutorial;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomGapHeight;

@end



@implementation TutorialTableViewCell

#pragma mark - Cell setup & skinning

- (void)awakeFromNib
{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.preservesSuperviewLayoutMargins = NO;
  [self.avatarImageView styleAsSmallAvatar];
  [self setupGradientOverlay];
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  self.backgroundImageView.image = nil;
}

- (void)setupGradientOverlay
{
  if (self.gradientLayer) {
    return;
  }
  self.gradientLayer = [GradientHelper addGradientLayerToView:self.gradientOverlayView];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.gradientLayer.frame = self.gradientOverlayView.bounds;
  
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

- (void)configureWithTutorial:(Tutorial *)tutorial
{
  self.tutorial = tutorial;
  
  [self updateBackgroundImageView];
  [self updateLikeButtonState];
  self.titleLabel.text = tutorial.title;
  self.authorLabel.text = tutorial.createdBy.name;
  self.sectionLabelContainer.titleLabel.text = tutorial.section.displayName;
  
  NSString *timeAgo = [tutorial.createdAt timeAgoSimple];
  self.timeLabel.text = timeAgo;
  
  [tutorial.createdBy placeAvatarInImageView:self.avatarImageView];
  // TODO: update favourited button state based on User's liked relation
  
  [self adjustAlphaFromTutorial:tutorial];
}

#pragma mark - Update UI to match Tutorial

- (void)updateBackgroundImageView
{
  if (self.tutorial.isDraft) {
    [self updateBackgroundImageViewFromTutorialData];
  }
  else {
    [self fetchBackgroundImageViewFromNetwork];
  }
}

- (void)updateBackgroundImageViewFromTutorialData
{
  if (!self.tutorial.isDraft) { // drafts don't have to contain imageData
    AssertTrueOrReturn(self.tutorial.pngImageData);
  }
  self.backgroundImageView.image = [UIImage imageWithData:self.tutorial.pngImageData];
}

- (void)fetchBackgroundImageViewFromNetwork
{
  __weak UIImageView *weakBackgroundImageView = self.backgroundImageView;
  
  NSString *imageURLString = self.tutorial.imageURL;
  AssertTrueOrReturn(imageURLString.length);
  NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tutorial.imageURL]];
  
  [self.backgroundImageView setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    weakBackgroundImageView.alpha = 0.0f;
    weakBackgroundImageView.image = image;
    [UIView animateWithDuration:kBackgroundImageViewFadeInDuration animations:^{
      weakBackgroundImageView.alpha = 1.0f;
    }];
  } failure:nil];
}

- (void)updateLikeButtonState
{
  self.favouriteButton.hidden = self.tutorial.isDraft;
  [self setFavouritedButtonState:self.likeButtonHighlighted];
}

- (BOOL)likeButtonHighlighted
{
  BOOL isDraft = (self.tutorial.isDraft);
  return (!isDraft && self.loggedInUserLikesTutorial);
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

- (void)adjustAlphaFromTutorial:(Tutorial *)tutorial
{
  CGFloat alpha = 1.0f;
  
  if (tutorial.primitiveDraftValue) {
    alpha = 0.5f;
  }
  else if (tutorial.primitiveInReviewValue) {
    alpha = 0.75f;
  }
  self.contentView.alpha = alpha;
}

#pragma mark - Other methods

- (void)setShowBottomGap:(BOOL)showBottomGap
{
  _showBottomGap = showBottomGap;
  CGFloat bottomGapHeight = [TutorialCellHelper new].bottomGapHeight;
  self.bottomGapHeight.constant = (showBottomGap ? bottomGapHeight : 0.0f);
}

#pragma mark - Auxiliary methods

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
  if (self.userAvatarSelectedBlock) {
    self.userAvatarSelectedBlock(self.tutorial.createdBy);
  }
}

@end
