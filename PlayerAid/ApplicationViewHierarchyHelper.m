//
//  PlayerAid
//

#import "ApplicationViewHierarchyHelper.h"
#import "CreateTutorialViewController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ProfileViewController.h"
#import "UsersController.h"
#import "TabBarHelper.h"

static const NSInteger kProfileViewControllerTabBarIndex = 3;


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
  
  AssertTrueOrReturnNil(viewControllers.count > kProfileViewControllerTabBarIndex);
  UIViewController* parentViewController = tabBarController.viewControllers[kProfileViewControllerTabBarIndex];
  AssertTrueOrReturnNil([parentViewController isKindOfClass:[UINavigationController class]]);
  
  UINavigationController *navigationController = (UINavigationController *)parentViewController;
  id firstViewController = navigationController.viewControllers.firstObject;
  AssertTrueOrReturnNil([firstViewController isKindOfClass:[ProfileViewController class]]);
  
  return firstViewController;
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
      [[UsersController sharedInstance] updateUsersProfile:user];
    }
  };
  return pushProfileViewBlock;
}

@end
