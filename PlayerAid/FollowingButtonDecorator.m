//
//  PlayerAid
//

#import "FollowingButtonDecorator.h"
#import "UserManipulationController.h"

static NSString *const kFollowImageLightBackgroundFilename = @"addfriend";
static NSString *const kFollowImageDarkBackgroundFilename = @"addfriend_off";
static NSString *const kUnfollowImageFilename = @"addfriend_on";


@implementation FollowingButtonDecorator

- (void)updateFollowingButtonImage:(UIButton *)addFriendButton forUser:(User *)user backgroundType:(BackgroundType)backgroundType
{
  AssertTrueOrReturn(user);
  AssertTrueOrReturn(addFriendButton);
  
  if (!user.loggedInUserValue) {
    BOOL following = [[UserManipulationController new] loggedInUserFollowsUser:user];
    NSString *imageName = (following ? kUnfollowImageFilename : [self followingImageFilenameForBackgroundType:backgroundType]);
    UIImage *image = [UIImage imageNamed:imageName];
    AssertTrueOrReturn(image);
    [addFriendButton setImage:image forState:UIControlStateNormal];
  }
}

- (NSString *)followingImageFilenameForBackgroundType:(BackgroundType)backgroundType
{
  return (backgroundType == BackgroundTypeLight ? kFollowImageLightBackgroundFilename : kFollowImageDarkBackgroundFilename);
}

@end
