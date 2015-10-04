//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonMacros.h>

@interface TabBarControllerHandler : NSObject <UITabBarControllerDelegate>

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithCreateTutorialItemAction:(void (^)())createTutorialAction;

@end
