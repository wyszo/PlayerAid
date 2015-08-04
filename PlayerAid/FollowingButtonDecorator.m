//
//  PlayerAid
//

#import "FollowingButtonDecorator.h"
#import "UserManipulationController.h"

static NSString *const kFollowImageLightBackgroundFilename = @"addfriend_off";
static NSString *const kFollowImageDarkBackgroundFilename = @"addfriend";
static NSString *const kUnfollowImageLightBackgroundFilename = @"addfriend_on";
static NSString *const kUnfollowImageDarkBackgroundFilename = @"addfriendprofileselect";


@implementation FollowingButtonDecorator

- (void)updateFollowingButtonImage:(UIButton *)addFriendButton forUser:(User *)user backgroundType:(BackgroundType)backgroundType
{
  AssertTrueOrReturn(user);
  AssertTrueOrReturn(addFriendButton);
  
  if (!user.loggedInUserValue) {
    BOOL following = [[UserManipulationController new] loggedInUserFollowsUser:user];
    NSString *imageName = (following ? [self unfollowingImageFilenameForBackgroundType:backgroundType] : [self followingImageFilenameForBackgroundType:backgroundType]);
    UIImage *image = [UIImage imageNamed:imageName];
    AssertTrueOrReturn(image);
    [addFriendButton setImage:image forState:UIControlStateNormal];
  }
}

- (NSString *)unfollowingImageFilenameForBackgroundType:(BackgroundType)backgroundType
{
  return (backgroundType == BackgroundTypeLight ? kUnfollowImageLightBackgroundFilename : kUnfollowImageDarkBackgroundFilename);
}

- (NSString *)followingImageFilenameForBackgroundType:(BackgroundType)backgroundType
{
  return (backgroundType == BackgroundTypeLight ? kFollowImageLightBackgroundFilename : kFollowImageDarkBackgroundFilename);
}

@end
