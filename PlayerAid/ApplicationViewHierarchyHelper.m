//
//  PlayerAid
//

@import KZAsserts;
@import BlocksKit;
#import "ApplicationViewHierarchyHelper.h"
#import "CreateTutorialViewController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ProfileViewController.h"
#import "UsersFetchController.h"
#import "PlayerAidTabBarHelper.h"
#import "AppDelegate.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "TutorialComment.h"
#import "EditProfileViewController.h"
#import "PlayerAid-Swift.h"

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

+ (void)presentEditProfileViewControllerFromViewController:(UIViewController *)presenter withUser:(User *)user didUpdateProfileBlock:(VoidBlock)didUpdateProfileBlock {

    AssertTrueOrReturn(presenter);
    AssertTrueOrReturn(user);

    EditProfileViewController *editProfileViewController = [[EditProfileViewController alloc] initWithUser:user];
    editProfileViewController.didUpdateUserProfileBlock = didUpdateProfileBlock;
    
    UINavigationController *navigationController = [ApplicationViewHierarchyHelper navigationControllerWithViewController:editProfileViewController];
    [presenter presentViewController:navigationController animated:YES completion:nil];
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
  [[UIViewControllerBehaviourDecorator new] installLeftEdgeSwipeToDismissBehaviourOnViewController:navigationController];
  
  [presentingViewController presentViewController:navigationController animated:YES completion:NULL];
  return commentRepliesVC;
}

+ (UIViewController *)presentCreateTutorialViewControllerForTutorial:(Tutorial *)tutorial isEditingDraft:(BOOL)editingDraft {
  AssertTrueOrReturnNil(tutorial);

  UIViewController *modalViewController = [self presentModalCreateTutorialViewController];
  AssertTrueOrReturnNil([modalViewController isKindOfClass:[CreateTutorialViewController class]]);

  CreateTutorialViewController *createTutorialViewController = (CreateTutorialViewController *)modalViewController;
  createTutorialViewController.tutorialToDisplay = tutorial;
  createTutorialViewController.isEditingDraft = editingDraft;

  return createTutorialViewController;
}

@end
