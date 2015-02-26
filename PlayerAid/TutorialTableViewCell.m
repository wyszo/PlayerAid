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


static const CGFloat kBottomGapHeight = 18.0f;
static const NSTimeInterval kBackgroundImageViewFadeInDuration = 0.3f;


@interface TutorialTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
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
  [self.avatarImageView styleAsSmallAvatar];
  [self setupGradientOverlay];
}

// TODO: extract this method somewhere
- (void)setupGradientOverlay
{
  if (self.gradientLayer) {
    return;
  }
  
  self.gradientOverlayView.alpha = 0.8;
  
  self.gradientLayer = [CAGradientLayer layer];
  self.gradientLayer.frame = self.gradientOverlayView.bounds;
  UIColor *darkBlue = [UIColor colorWithRed:24.0/255.0 green:45.0/255.0 blue:97.0/255.0 alpha:1.0];
  self.gradientLayer.colors = @[ (id)[[UIColor colorWithWhite:1.0 alpha:0] CGColor], (id)[darkBlue CGColor] ];
  self.gradientLayer.shouldRasterize = YES;
  self.gradientLayer.rasterizationScale = [UIScreen mainScreen].scale;
  
  [self.gradientOverlayView.layer insertSublayer:self.gradientLayer atIndex:0];
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
      frame.size.height = self.frame.size.height - kBottomGapHeight;
      deleteButtonView.frame = frame;
    }
  }
  // TODO: this approach sucks - gaps between tableView cells are implemented as part of cells, instead of dummy sections. That's why we traverse view hierarchy to decrease size of a delete button. Likely to break in future iOS versions.
}

- (void)configureWithTutorial:(Tutorial *)tutorial
{
  self.tutorial = tutorial;
  
  [self updateBackgroundImageView];
  self.titleLabel.text = tutorial.title;
  self.authorLabel.text = tutorial.createdBy.name;
  self.sectionLabel.text = tutorial.section.name;
  
  NSString *timeAgo = [tutorial.createdAt timeAgoSimple];
  self.timeLabel.text = timeAgo;
  
  [tutorial.createdBy placeAvatarInImageView:self.avatarImageView];
  [self setFavouritedButtonState:tutorial.favouritedValue];
  
  [self adjustAlphaFromTutorial:tutorial];
}

- (void)updateBackgroundImageView
{
  __weak UIImageView *weakBackgroundImageView = self.backgroundImageView;
  NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tutorial.imageURL]];
  
  [self.backgroundImageView setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    weakBackgroundImageView.alpha = 0.0f;
    weakBackgroundImageView.image = image;
    [UIView animateWithDuration:kBackgroundImageViewFadeInDuration animations:^{
      weakBackgroundImageView.alpha = 1.0f;
    }];
  } failure:nil];
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
  self.bottomGapHeight.constant = (showBottomGap ? kBottomGapHeight : 0.0f);
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
  BOOL newState = !self.tutorial.favouritedValue;
  
  [self setFavouritedButtonState:newState];
  if (self.tutorialFavouritedBlock) {
    self.tutorialFavouritedBlock(newState);
  }
}

- (IBAction)authorButtonPressed:(id)sender
{
  if (self.userAvatarSelectedBlock) {
    self.userAvatarSelectedBlock(self.tutorial.createdBy);
  }
}

#pragma mark - Class methods

+ (CGFloat)cellHeightForCellWithBottomGap:(BOOL)includeBottomGap
{
  static CGFloat cellHeightWithGap;
  if (!cellHeightWithGap)
  {
    cellHeightWithGap = [TutorialCellHelper cellHeightFromNib];
  }
  
  static CGFloat cellHeightWithoutGap;
  if (!cellHeightWithoutGap)
  {
    cellHeightWithoutGap = [TutorialCellHelper cellHeightFromNib] - kBottomGapHeight;
  }
  return (includeBottomGap ? cellHeightWithGap : cellHeightWithoutGap);
}

@end
