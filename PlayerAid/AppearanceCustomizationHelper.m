//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KZAsserts.h>
#import "AppearanceCustomizationHelper.h"
#import "ColorsHelper.h"
#import "ApplicationViewHierarchyHelper.h"
#import "FontsHelper.h"


static const NSUInteger kTabBarCreateTutorialItemIndex = 2;


@implementation AppearanceCustomizationHelper

#pragma mark - public

- (void)customizeApplicationAppearance
{
  [self customizeStatusBarAppearance];
  [self customizeNavigationBarsAppearance];
  [self customizeNavigationBarButtonsAppearance];
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
  
  UIFont *font = [FontsHelper navbarTitleFont];
  AssertTrueOrReturn(font);
  [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : font
                                                        }];
}

- (void)customizeNavigationBarButtonsAppearance
{
  UIFont *font = [FontsHelper navbarButtonsFont];
  AssertTrueOrReturn(font);
  [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : font
                                                        } forState:UIControlStateNormal];
}

- (void)customizeTabbar
{
  [self customizeTabbarFontColors];
  [self customizeTabbarTintColors];
  [self customizeTabbarItemTitles];
  [self customizeCreateTutorialTabBarButton];
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

- (void)customizeCreateTutorialTabBarButton
{
  [self customizeCreateTutorialTabBarButtonBackground];
  [self customizeCreateTutorialTabBarButtonFont];
}

- (void)customizeCreateTutorialTabBarButtonBackground
{
  CGRect frame = [ApplicationViewHierarchyHelper frameForTabBarItemAtIndex:kTabBarCreateTutorialItemIndex];

  UIView *createButtonBackgroundView = [[UIView alloc] initWithFrame:frame];
  UIColor *createButtonBackgroundColor = [ColorsHelper tabBarCreateTutorialBackgroundColor];
  createButtonBackgroundView.backgroundColor = createButtonBackgroundColor;
 
  UITabBarController *tabBarController = [ApplicationViewHierarchyHelper applicationTabBarController];
  [tabBarController.tabBar insertSubview:createButtonBackgroundView atIndex:0];
}

- (void)customizeCreateTutorialTabBarButtonFont
{
  UITabBarItem *createTutorialTabBarItem = [ApplicationViewHierarchyHelper tabBarItemAtIndex:kTabBarCreateTutorialItemIndex];
  NSDictionary *attributes = @{ NSForegroundColorAttributeName : [ColorsHelper tabBarCreateTutorialTextColor] };
  
  [createTutorialTabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
  [createTutorialTabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
  
  UIImage *createTutorialOriginalImage = [[UIImage imageNamed:@"createtutorial"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  createTutorialTabBarItem.image = createTutorialOriginalImage;
  createTutorialTabBarItem.selectedImage = createTutorialOriginalImage;
}

@end
