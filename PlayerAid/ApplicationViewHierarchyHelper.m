//
//  PlayerAid
//

@import KZAsserts;
#import "ApplicationViewHierarchyHelper.h"
#import "CreateTutorialViewController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ProfileViewController.h"
#import "UsersFetchController.h"
#import "PlayerAidTabBarHelper.h"
#import "AppDelegate.h"

@implementation ApplicationViewHierarchyHelper

#pragma mark - Navigation Controllers

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController
{
  CreateTutorialViewController *createTutorialViewController = [CreateTutorialViewController new];
  return [self navigationControllerWithViewController:createTutorialViewController];
}

+ (UINavigationController *)navigationControllerWithViewController:(UIViewController *)viewController
{
  AssertTrueOrReturnNil(viewController);
  
  UINavigationController *navigationController = [[NavigationControllerWhiteStatusbar alloc] initWithRootViewController:viewController];
  AssertTrueOrReturnNil(navigationController);
  return navigationController;
}

#pragma mark - Profile

+ (void (^)(User *))pushProfileViewControllerFromViewController:(UIViewController *)viewController backButtonActionBlock:(VoidBlock)backButtonAction allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser
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
    profileViewController.backButtonAction = backButtonAction;
    
    UINavigationController *navigationController = weakViewController.navigationController;
    AssertTrueOrReturn(navigationController);
    [navigationController pushViewController:profileViewController animated:YES];
    
    if (!user.loggedInUserValue) {
      [[UsersFetchController sharedInstance] fetchUsersProfile:user];
    }
  };
  return pushProfileViewBlock;
}

#pragma mark - Presenting CreateTutorial

+ (UIViewController *)presentModalCreateTutorialViewController
{
  UINavigationController *navigationController = [self navigationControllerWithCreateTutorialViewController];
  AssertTrueOrReturnNil(navigationController);
  
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
  
  return navigationController.topViewController;
}

@end
