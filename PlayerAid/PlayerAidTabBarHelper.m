//
//  PlayerAid
//

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

@end
