//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "JourneyController.h"
#import "TabBarHelper.h"
#import "AppDelegate.h"
#import "ApplicationViewHierarchyHelper.h"
#import "FacebookAuthenticationController.h"
#import "DataCleanupHelper.h"

static NSString *const kLoginSegueId = @"LoginSegue";
static NSString *const kAnimatedLoginSegueId = @"LoginSegueAnimated";


@implementation JourneyController

- (void)clearAppDataAndPerformLoginSegueAnimated:(BOOL)animated
{
  [[FacebookAuthenticationController new] logout]; // TODO: inject FAC as an external dependency
  
  DataCleanupHelper *cleanupHelper = [DataCleanupHelper new];
  [cleanupHelper clearUserDefaults];
  [cleanupHelper deleteAndRecreateCoreDataStore];
  
  [self performLoginSegueAnimated:animated];
}

- (void)performLoginSegueAnimated:(BOOL)animated
{
  [self ensureMainWindowKeyAndVisible];
  [self pushLoginNavigationControllerAnimated:animated];
}

- (void)ensureMainWindowKeyAndVisible
{
  if (!self.appDelegate.window.keyWindow) {
    [self.appDelegate.window makeKeyAndVisible];  // need to call this when we try to perform segue early after initialization
  }
}

#pragma mark - Login Navigation Controller

- (void)pushLoginNavigationControllerAnimated:(BOOL)animated {
  UIViewController *vc = [self loginNavigationController];
  UITabBarController *mainTabBarController = [TabBarHelper mainTabBarController];
  [mainTabBarController presentViewController:vc animated:animated completion:nil];
}

- (UIViewController *)loginNavigationController {
  UIViewController *navigationController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
  AssertTrueOrReturnNil(navigationController);
  return navigationController;
}

#pragma mark - DEBUG methods

- (void)DEBUG_presentCreateTutorialViewController
{
  DISPATCH_AFTER(0.1, ^{
    [ApplicationViewHierarchyHelper presentModalCreateTutorialViewController];
  });
}

- (void)DEBUG_presentProfile
{
  // right now profile is last tabBar item (no settings)
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  tabBarController.selectedViewController = tabBarController.viewControllers.lastObject;
}

- (void)DEBUG_presentSettings
{
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  tabBarController.selectedViewController = tabBarController.viewControllers.lastObject;
}

#pragma mark - Helper methods

- (AppDelegate *)appDelegate
{
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  AssertTrueOrReturnNil(appDelegate);
  return appDelegate;
}

@end
