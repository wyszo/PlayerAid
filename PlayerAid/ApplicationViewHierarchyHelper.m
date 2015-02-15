//
//  PlayerAid
//

#import "ApplicationViewHierarchyHelper.h"
#import <KZAsserts.h>


@implementation ApplicationViewHierarchyHelper

+ (UITabBarController *)applicationTabBarController
{
  id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
  UIViewController *rootViewController = appDelegate.window.rootViewController;
  
  AssertTrueOrReturnNil([rootViewController isKindOfClass:[UITabBarController class]]);
  UITabBarController *tabBarController = (UITabBarController *)rootViewController;
  return tabBarController;
}

+ (UITabBarItem *)tabBarItemAtIndex:(NSInteger)itemIndex
{
  UITabBarController *tabBarController = [ApplicationViewHierarchyHelper applicationTabBarController];
  AssertTrueOrReturnNil(tabBarController.tabBar.items.count > itemIndex);
  return tabBarController.tabBar.items[itemIndex];
}

@end
