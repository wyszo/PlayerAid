//
//  PlayerAid
//

#import "FollowedUserTableViewCell.h"
#import "UIImageView+AvatarStyling.h"
#import "FollowingButtonDecorator.h"
#import "UserManipulationController.h"


@interface FollowedUserTableViewCell ()
@property (weak, nonatomic) User *user;
@end


@implementation FollowedUserTableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self.avatarImageView makeCircular];
}

#pragma mark - Cell configuration

- (void)configureWithUser:(User *)user
{
  AssertTrueOrReturn(user);
  self.user = user;
  
  self.nameLabel.text = user.name;
  self.descriptionLabel.text = user.userDescription;
  [user placeAvatarInImageView:self.avatarImageView];
  
  [self updateFollowingButtonVisibility];
  [self updateFollowingButtonImage];
}

- (void)updateFollowingButtonVisibility
{
  AssertTrueOrReturn(self.user);
  if (self.user.loggedInUserValue) {
    self.followingButton.hidden = YES;
  }
}

- (void)updateFollowingButtonImage
{
  AssertTrueOrReturn(self.user);
  [[FollowingButtonDecorator new] updateFollowingButtonImage:self.followingButton forUser:self.user backgroundType:BackgroundTypeLight];
}

#pragma mark - IBActions

- (IBAction)followUnfollowButtonPressed:(id)sender
{
  AssertTrueOrReturn(self.user);
  defineWeakSelf();
  
  [[UserManipulationController new] toggleFollowButtonPressedSendRequestUpdateModelForUser:self.user completion:^(NSError *error) {
    if (!error) {
      [weakSelf updateFollowingButtonImage];
    }
  }];
}

@end
