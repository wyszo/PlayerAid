//
//  PlayerAid
//

@import Foundation;
#import "TabBarHelper.h"

@class NewProfileViewController;

/**
 TabBar utility methods that require assumptions about available tabBar items
 */
@interface PlayerAidTabBarHelper : NSObject

+ (UITabBarItem *)createTutorialTabBarItem;
+ (CGRect)frameForCreateTutorialTabBarItem;

/**
 Returns ProfileViewController provided it's embeded directly in TabBarController or firstObject of a NavigationController in TabBar
 */
+ (NewProfileViewController *)tabBarProfileViewController;

@end
