//
//  PlayerAid
//

#import "ApplicationViewHierarchyHelper.h"
#import "CreateTutorialViewController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ProfileViewController.h"
#import "UsersController.h"


@implementation ApplicationViewHierarchyHelper

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController
{
  CreateTutorialViewController *createTutorialViewController = [[CreateTutorialViewController alloc] initWithNibName:@"CreateTutorialView" bundle:[NSBundle mainBundle]];
  UINavigationController *navigationController = [[NavigationControllerWhiteStatusbar alloc] initWithRootViewController:createTutorialViewController];
  AssertTrueOrReturnNil(navigationController);
  return navigationController;
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
