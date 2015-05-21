//
//  PlayerAid
//

#import "TabBarBadgeHelper.h"
#import "ApplicationViewHierarchyHelper.h"


@implementation TabBarBadgeHelper

#pragma mark - Public methods

- (void)showProfileTabBarItemBadge
{
  UITabBarItem *profileTabBarItem = [self profileTabBarItem];
  NSNumber *badgeNumber = @1;
  
  NSString *oldBadgeValue = profileTabBarItem.badgeValue;
  if (oldBadgeValue.length) {
    badgeNumber = @([oldBadgeValue integerValue] + 1);
  }
  profileTabBarItem.badgeValue = [badgeNumber stringValue];
}

- (void)hideProfileTabBarItemBadge
{
  self.profileTabBarItem.badgeValue = nil;
}

#pragma mark - Private

- (UITabBarItem *)profileTabBarItem
{
  UIViewController *profileViewControler = ApplicationViewHierarchyHelper.profileViewControllerFromTabBarController;
  UITabBarItem *profileTabBarItem = profileViewControler.navigationController.tabBarItem;
  AssertTrueOrReturnNil(profileTabBarItem);
  return profileTabBarItem;
}

@end
