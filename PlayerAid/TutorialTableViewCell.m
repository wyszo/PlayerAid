//
//  PlayerAid
//

#import "TutorialTableViewCell.h"
#import <KZAsserts.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AvatarStyling.h"
#import "User.h"
#import "Section.h"


@interface TutorialTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UIView *sectionTitleBackground;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIView *gradientOverlayView;

@property (weak, nonatomic) Tutorial *tutorial;

@end


@implementation TutorialTableViewCell

- (void)awakeFromNib
{
  [self.avatarImageView styleAsSmallAvatar];
  [self setupGradientOverlay];
}

- (void)setupGradientOverlay
{
  self.gradientOverlayView.alpha = 0.8;
  
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  gradientLayer.frame = self.gradientOverlayView.bounds;
  UIColor *darkBlue = [UIColor colorWithRed:24.0/255.0 green:45.0/255.0 blue:97.0/255.0 alpha:1.0];
  gradientLayer.colors = @[ (id)[[UIColor clearColor] CGColor], (id)[darkBlue CGColor] ];
  [self.gradientOverlayView.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)configureWithTutorial:(Tutorial *)tutorial
{
  self.tutorial = tutorial;
  
  self.titleLabel.text = tutorial.title;
  self.authorLabel.text = tutorial.createdBy.username;
  self.sectionLabel.text = tutorial.section.name;
//  self.timeLabel.text = // tutorial.createdAt -> string // TODO: display creation date
  
  self.avatarImageView.image = tutorial.createdBy.avatarImage;
  [self setFavouritedButtonState:tutorial.favouritedValue];
  
  [self adjustAlphaFromTutorial:tutorial];
}

-(void)adjustAlphaFromTutorial:(Tutorial *)tutorial
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

@end
