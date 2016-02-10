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
#import "NavigationControllerWhiteStatusbar.h"
#import "PlayerAid-Swift.h"
#import "TutorialComment.h"

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

+ (void (^)(User *))pushProfileVCFromNavigationController:(UINavigationController *)navigationController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser {
  AssertTrueOrReturnNil(navigationController);

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

    [navigationController pushViewController:profileViewController animated:YES];
    
    if (!user.loggedInUserValue) {
      [[UsersFetchController sharedInstance] fetchUsersProfile:user];
    }
  };
  return pushProfileViewBlock;
}

#pragma mark - Custom ViewControllers presentation

+ (UIViewController *)presentModalCreateTutorialViewController
{
  UINavigationController *navigationController = [self navigationControllerWithCreateTutorialViewController];
  AssertTrueOrReturnNil(navigationController);
  
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window.rootViewController presentViewController:navigationController animated:YES completion:NULL];
  
  return navigationController.topViewController;
}

+ (UIViewController *)presentModalCommentReplies:(TutorialComment *)comment fromViewController:(UIViewController *)presentingViewController {
  AssertTrueOrReturnNil(comment);
  AssertTrueOrReturnNil(presentingViewController);
  
  CommentRepliesViewController *commentRepliesVC = [[CommentRepliesViewController alloc] initWithCommentID:[comment.serverID integerValue]];
  UINavigationController *navigationController = [[NavigationControllerWhiteStatusbar alloc] initWithRootViewController:commentRepliesVC];
  [presentingViewController presentViewController:navigationController animated:YES completion:NULL];

  return commentRepliesVC;
}

@end
