//
//  PlayerAid
//

#import "User.h"
@import UIKit;
@import Foundation;

typedef NS_ENUM(NSInteger, BackgroundType) {
  BackgroundTypeLight,
  BackgroundTypeDark
};


@interface FollowingButtonDecorator : NSObject

- (void)updateFollowingButtonImage:(UIButton *)addFriendButton forUser:(User *)user backgroundType:(BackgroundType)backgroundType;

@end
