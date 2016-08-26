//
//  PlayerAid
//

@import KZAsserts;
#import "PlayerAidTabBarHelper.h"
#import "TabBarHelper.h"
#import "CreateTutorialViewController.h"
#import "PlayerAid-Swift.h"

@implementation PlayerAidTabBarHelper

#pragma mark - Helpers for specific tabbar items

+ (UITabBarItem *)createTutorialTabBarItem
{
  NSNumber *indexNumber = [TabBarHelper tabBarControllerIndexOfViewControllerWithType:[CreateTutorialViewController class]];
  AssertTrueOrReturnNil(indexNumber != nil);
  
  UITabBarItem *createTutorialTabBarItem = [TabBarHelper mainTabBarController].tabBar.items[indexNumber.unsignedIntegerValue];
  AssertTrueOrReturnNil(createTutorialTabBarItem != nil);
  
  return createTutorialTabBarItem;
}

+ (CGRect)frameForCreateTutorialTabBarItem
{
  NSNumber *indexNumber = [TabBarHelper tabBarControllerIndexOfViewControllerWithType:[CreateTutorialViewController class]];
  AssertTrueOr(indexNumber != nil, return CGRectZero;);
  
  return [TabBarHelper frameForTabBarItemAtIndex:indexNumber.unsignedIntegerValue];
}

+ (NewProfileViewController *)tabBarProfileViewController
{
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  __block NewProfileViewController *profileViewController;
  
  [tabBarController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
    if ([viewController isKindOfClass:NewProfileViewController.class]) {
      profileViewController = (NewProfileViewController *)viewController;
      *stop = YES;
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      UINavigationController *navigationController = (UINavigationController *)viewController;
      UIViewController *navigationControllerFirstObject = navigationController.viewControllers.firstObject;
      
      if ([navigationControllerFirstObject isKindOfClass:NewProfileViewController.class]) {
        profileViewController = (NewProfileViewController *)navigationControllerFirstObject;
        *stop = YES;
      }
    }
  }];
  
  AssertTrueOrReturnNil(profileViewController);
  return profileViewController;
}

@end
