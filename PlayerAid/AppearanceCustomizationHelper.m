//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KZAsserts.h>
#import "AppearanceCustomizationHelper.h"
#import "ColorsHelper.h"
#import "ApplicationViewHierarchyHelper.h"


@implementation AppearanceCustomizationHelper

#pragma mark - public

- (void)customizeApplicationAppearance
{
  [self customizeStatusBarAppearance];
  [self customizeNavigationBarsAppearance];
  [self customizeTabbar];
}

#pragma mark - private implementation

- (void)customizeStatusBarAppearance
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
}

- (void)customizeNavigationBarsAppearance
{
  [[UINavigationBar appearance] setBarTintColor:[ColorsHelper navigationBarColor]];
  [[UINavigationBar appearance] setTintColor:[ColorsHelper navigationBarButtonsColor]]; 
  [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

- (void)customizeTabbar
{
  [self customizeTabbarFontColors];
  [self customizeTabbarTintColors];
  [self customizeTabbarItemTitles];
  [self customiseCreateTutorialTabBarButtonBackground];
}

- (void)customizeTabbarFontColors
{
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorsHelper tabBarUnselectedTextColor] } forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorsHelper tabBarSelectedTextColor] } forState:UIControlStateSelected];
}

- (void)customizeTabbarTintColors
{
  [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
  [[UITabBar appearance] setSelectedImageTintColor:[ColorsHelper tabBarSelectedImageTintColor]];
}

- (void)customizeTabbarItemTitles
{
  [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
  
  UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:10.0f];
  AssertTrueOrReturn(font);
  
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : font } forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : font } forState:UIControlStateSelected];
}

#pragma mark - Create Tutorial TabBar button

- (void)customiseCreateTutorialTabBarButtonBackground
{
  UITabBarController *tabBarController = [ApplicationViewHierarchyHelper applicationTabBarController];
  const NSUInteger createItemIndex = 2;
  
  AssertTrueOrReturn(tabBarController.tabBar.items.count > createItemIndex);
  
  UITabBar *tabBar = tabBarController.tabBar;
  CGFloat tabbarItemWidth = tabBar.frame.size.width / (CGFloat)tabBar.items.count;
  UIView *createButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(tabbarItemWidth * createItemIndex, 0, tabbarItemWidth, tabBar.frame.size.height)];
  
  UIColor *createButtonBackgroundColor = [ColorsHelper tabBarCreateTutorialBackgroundColor];
  createButtonBackgroundView.backgroundColor = createButtonBackgroundColor;
  
  [tabBar insertSubview:createButtonBackgroundView atIndex:0];
}

@end
