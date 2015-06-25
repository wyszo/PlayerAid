//
//  PlayerAid
//

#import "User.h"


typedef NS_ENUM(NSInteger, BackgroundType) {
  BackgroundTypeLight,
  BackgroundTypeDark
};


@interface FollowingButtonDecorator : NSObject

- (void)updateFollowingButtonImage:(UIButton *)addFriendButton forUser:(User *)user backgroundType:(BackgroundType)backgroundType;

@end
