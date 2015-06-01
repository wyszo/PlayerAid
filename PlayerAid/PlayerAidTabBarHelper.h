//
//  PlayerAid
//

#import "TabBarHelper.h"


/**
 TabBar utility methods that require assumptions about available tabBar items
 */
@interface PlayerAidTabBarHelper : NSObject

+ (UITabBarItem *)createTutorialTabBarItem;
+ (CGRect)frameForCreateTutorialTabBarItem;

@end
