//
//  PlayerAid
//

#import "ApplicationViewHierarchyHelper.h"
#import "CreateTutorialViewController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ProfileViewController.h"
#import "UsersFetchController.h"
#import "TabBarHelper.h"

static const NSInteger kProfileViewControllerTabBarIndex = 2; // index == 2 when there are no 'Browse' and 'Settings' tabs or 3 when they're wired up
static const NSInteger kProfileTabBarItemTag = 301;


@implementation ApplicationViewHierarchyHelper

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController
{
  CreateTutorialViewController *createTutorialViewController = [[CreateTutorialViewController alloc] initWithNibName:@"CreateTutorialView" bundle:[NSBundle mainBundle]];
  UINavigationController *navigationController = [[NavigationControllerWhiteStatusbar alloc] initWithRootViewController:createTutorialViewController];
  AssertTrueOrReturnNil(navigationController);
  return navigationController;
}

+ (ProfileViewController *)profileViewControllerFromTabBarController
{
  // Poor way to do this - just hardcoding index item and then checking if it really corresponds to ProfileViewController
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  NSArray *viewControllers = tabBarController.viewControllers;
  
  [self.class verifyProfileTabBarIndex];
  
  AssertTrueOrReturnNil(viewControllers.count > kProfileViewControllerTabBarIndex);
  UIViewController* parentViewController = tabBarController.viewControllers[kProfileViewControllerTabBarIndex];
  AssertTrueOrReturnNil([parentViewController isKindOfClass:[UINavigationController class]]);
  
  UINavigationController *navigationController = (UINavigationController *)parentViewController;
  id firstViewController = navigationController.viewControllers.firstObject;
  AssertTrueOrReturnNil([firstViewController isKindOfClass:[ProfileViewController class]]);
  
  return firstViewController;
}

+ (void)verifyProfileTabBarIndex
{
  UITabBarItem *profileTabBarItem = [TabBarHelper tabBarItemAtIndex:kProfileViewControllerTabBarIndex];
  AssertTrueOrReturn(profileTabBarItem.tag == kProfileTabBarItemTag && @"Ensure kProfileViewControllerTabBarIndex points to profile tabbar item and that the item has tag equal kProfileTabBarItemTag in interface builder");
}

+ (void (^)(User *))pushProfileViewControllerFromViewControllerBlock:(UIViewController *)viewController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser
{
  __weak UIViewController *weakViewController = viewController;
  
  void (^pushProfileViewBlock)(User *) = ^(User *user) {
    AssertTrueOrReturn(user);
    
    if (!allowPushingLoggedInUser && user.loggedInUserValue) {
      return;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AssertTrueOrReturn(mainStoryboard);
    
    ProfileViewController *profileViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    AssertTrueOrReturn(profileViewController);
    profileViewController.user = user;
    
    UINavigationController *navigationController = weakViewController.navigationController;
    AssertTrueOrReturn(navigationController);
    [navigationController pushViewController:profileViewController animated:YES];
    
    if (!user.loggedInUserValue) {
      [[UsersFetchController sharedInstance] fetchUsersProfile:user];
    }
  };
  return pushProfileViewBlock;
}

@end
