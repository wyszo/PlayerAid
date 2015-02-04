//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KZAsserts.h>
#import "AppearanceCustomizationHelper.h"
#import "ColorsHelper.h"


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
  [self customizeTabbarFonts];
  [self customizeTabbarTintColors];
  [self customizeTabbarTitles];
  [self customiseCreateTutorialTabBarButtonBackground];
}

- (void)customizeTabbarFonts
{
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorsHelper tabBarUnselectedTextColor] }  forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorsHelper tabBarSelectedTextColor] } forState:UIControlStateSelected];
}

- (void)customizeTabbarTintColors
{
  [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
  [[UITabBar appearance] setSelectedImageTintColor:[ColorsHelper tabBarSelectedImageTintColor]];
}

- (void)customizeTabbarTitles
{
  [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
  
  [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                      [UIFont fontWithName:@"Helvetica Neue" size:11.0f] : NSFontAttributeName
                                                      }
                                           forState:UIControlStateNormal];
}

- (void)customiseCreateTutorialTabBarButtonBackground
{
  UITabBarController *tabBarController = [self applicationTabBarController];
  const NSUInteger createItemIndex = 2;
  
  AssertTrueOrReturn(tabBarController.tabBar.items.count > createItemIndex);
  
  UITabBar *tabBar = tabBarController.tabBar;
  CGFloat tabbarItemWidth = tabBar.frame.size.width / (CGFloat)tabBar.items.count;
  UIView *createButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(tabbarItemWidth * createItemIndex, 0, tabbarItemWidth, tabBar.frame.size.height)];
  
  UIColor *createButtonBackgroundColor = [ColorsHelper tabBarCreateTutorialBackgroundColor];
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
