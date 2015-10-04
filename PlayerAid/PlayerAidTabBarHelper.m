//
//  PlayerAid
//

@import KZAsserts;
#import "PlayerAidTabBarHelper.h"
#import "TabBarHelper.h"
#import "CreateTutorialViewController.h"


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

+ (ProfileViewController *)tabBarProfileViewController
{
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  __block ProfileViewController *profileViewController;
  
  [tabBarController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
    if ([viewController isKindOfClass:ProfileViewController.class]) {
      profileViewController = (ProfileViewController *)viewController;
      *stop = YES;
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      UINavigationController *navigationController = (UINavigationController *)viewController;
      UIViewController *navigationControllerFirstObject = navigationController.viewControllers.firstObject;
      
      if ([navigationControllerFirstObject isKindOfClass:ProfileViewController.class]) {
        profileViewController = (ProfileViewController *)navigationControllerFirstObject;
        *stop = YES;
      }
    }
  }];
  
  AssertTrueOrReturnNil(profileViewController);
  return profileViewController;
}

@end
