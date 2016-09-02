//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "FollowedUserTableViewCell.h"
#import "UIImageView+AvatarStyling.h"
#import "FollowingButtonDecorator.h"
#import "UserManipulationController.h"
#import "PlayerAid-Swift.h"

@interface FollowedUserTableViewCell ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightEqualZeroConstraint;
@property (weak, nonatomic) User *user;
@end

@implementation FollowedUserTableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self.avatarImageView makeCircularSetAspectFit];
}

#pragma mark - Cell configuration

- (void)configureWithUser:(User *)user
{
  AssertTrueOrReturn(user);
  self.user = user;
  
  self.nameLabel.text = user.name;
  
  [user placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSizeMedium];
  
  NSString *trimmedDescription = [user.userDescription tw_condensedWhitespace];
  self.descriptionLabel.text = trimmedDescription;
  
  [self updateFollowingButtonVisibility];
  [self updateFollowingButtonImage];
  [self updateDescriptionHeightForUserDescription:trimmedDescription];
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

- (void)updateDescriptionHeightForUserDescription:(NSString *)userDescription {
    AssertTrueOrReturn(self.heightEqualZeroConstraint);

    BOOL hideDescription = (userDescription.length == 0);
    if (userDescription == nil) {
        hideDescription = YES;
    }
    self.heightEqualZeroConstraint.active = hideDescription;
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
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
