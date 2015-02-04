//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KZAsserts.h>
#import "AppearanceCustomizationHelper.h"

@implementation AppearanceCustomizationHelper

#pragma mark - public

- (void)customizeApplicationAppearance
{
  [self customizeStatusAndNavigationBarsAppearance];
  [self customizeTabbar];
}

#pragma mark - private implementation

- (void)customizeStatusAndNavigationBarsAppearance
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // White fonts in statusbar and Navigation bars
  [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

- (void)customizeTabbar
{
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor greenColor] }  forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateSelected];
  
  [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
  
  [self customiseCreateTutorialTabBarButtonBackground];
}

- (void)customiseCreateTutorialTabBarButtonBackground
{
  UITabBarController *tabBarController = [self applicationTabBarController];
  const NSUInteger createItemIndex = 2;
  
  AssertTrueOrReturn(tabBarController.tabBar.items.count > createItemIndex);
  
  UITabBar *tabBar = tabBarController.tabBar;
  CGFloat tabbarItemWidth = tabBar.frame.size.width / (CGFloat)tabBar.items.count;
  UIView *createButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(tabbarItemWidth * createItemIndex, 0, tabbarItemWidth, tabBar.frame.size.height)];
  
  UIColor *createButtonBackgroundColor = [UIColor colorWithRed:1.00 green:0.07 blue:0.7 alpha:1.0];
  createButtonBackgroundView.backgroundColor = createButtonBackgroundColor;
  
  [tabBar insertSubview:createButtonBackgroundView atIndex:0];
}

- (UITabBarController *)applicationTabBarController
{
  id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
  UIViewController *rootViewController = appDelegate.window.rootViewController;
  
  AssertTrueOrReturnNil([rootViewController isKindOfClass:[UITabBarController class]]);
  UITabBarController *tabBarController = (UITabBarController *)rootViewController;
  return tabBarController;
}

@end
