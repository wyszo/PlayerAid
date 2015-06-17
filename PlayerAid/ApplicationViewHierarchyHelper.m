//
//  PlayerAid
//

#import "ApplicationViewHierarchyHelper.h"
#import "CreateTutorialViewController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ProfileViewController.h"
#import "UsersFetchController.h"
#import "PlayerAidTabBarHelper.h"

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

+ (void (^)(User *))pushProfileViewControllerFromViewController:(UIViewController *)viewController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser
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
