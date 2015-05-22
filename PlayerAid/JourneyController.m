//
//  PlayerAid
//

#import "JourneyController.h"
#import "TabBarHelper.h"
#import "AppDelegate.h"
#import "ApplicationViewHierarchyHelper.h"
#import "FacebookAuthenticationController.h"
#import "DataCleanupHelper.h"


@implementation JourneyController

- (void)clearAppDataAndPerformLoginSegueAnimated:(BOOL)animated
{
  [FacebookAuthenticationController logout];
  
  DataCleanupHelper *cleanupHelper = [DataCleanupHelper new];
  [cleanupHelper clearUserDefaults];
  [cleanupHelper deleteAndRecreateCoreDataStore];
  
  [self performLoginSegueAnimated:animated];
}

- (void)performLoginSegueAnimated:(BOOL)animated
{
  [self ensureMainWindowKeyAndVisible];
  
  NSString *loginSegueName = @"LoginSegue";
  if (animated) {
    loginSegueName = [loginSegueName stringByAppendingString:@"Animated"];
  }
  [[TabBarHelper mainTabBarController] performSegueWithIdentifier:loginSegueName sender:nil];
}

- (void)ensureMainWindowKeyAndVisible
{
  if (!self.appDelegate.window.keyWindow) {
    [self.appDelegate.window makeKeyAndVisible];  // need to call this when we try to perform segue early after initialization
  }
}

#pragma mark - DEBUG methods

- (void)DEBUG_presentCreateTutorialViewController
{
  __strong typeof(self) strongSelf = self; // explicitly extending whole object's lifetime
  DISPATCH_AFTER(0.1, ^{
    UIViewController *viewController = [ApplicationViewHierarchyHelper navigationControllerWithCreateTutorialViewController];
    AssertTrueOrReturn(viewController);
    [strongSelf.appDelegate.window.rootViewController presentViewController:viewController animated:YES completion:nil];
  });
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
