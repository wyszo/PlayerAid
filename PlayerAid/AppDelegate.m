//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <MagicalRecord+Setup.h>
#import "AppDelegate.h"
#import "AppearanceCustomizationHelper.h"
#import "TabBarControllerHandler.h"
#import "CreateTutorialViewController.h"
#import "TabBarHelper.h"
#import "AuthenticationController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "UsersController.h"
#import "ServerDataUpdateController.h"
#import "ApplicationViewHierarchyHelper.h"
#import "SectionsDataSource.h"


@interface AppDelegate () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarControllerHandler *tabBarControllerHandler;
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"PlayerAidStore"];
  [SectionsDataSource setupHardcodedSectionsIfNeedded];
  
  [self applicationLaunchDataFetch];
  
  [[AppearanceCustomizationHelper new] customizeApplicationAppearance];
  [self setupTabBarActionHandling];
  
  return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [self applicationLaunchDataFetch];
}

- (void)applicationLaunchDataFetch
{
  if (!DEBUG_OFFLINE_MODE) {
    [AuthenticationController checkIsUserAuthenticatedPingServerCompletion:^(BOOL authenticated) {
      if (authenticated) {
        [ServerDataUpdateController updateUserAndTutorials];
      }
      else {
        [self performLoginSegue]; // note this has to be called after setting up core data stack
      }
    }];
  }
  
  if (DEBUG_MODE_FLOW_EDIT_TUTORIAL || DEBUG_MODE_FLOW_PUBLISH_TUTORIAL || DEBUG_MODE_ADD_TUTORIAL_STEPS || DEBUG_MODE_ADD_PHOTO) {
    [self DEBUG_presentCreateTutorialViewController];
  }
  
  if (DEBUG_MODE_PUSH_SETTINGS) {
    [self DEBUG_presentSettings];
  }
}

- (void)DEBUG_presentCreateTutorialViewController
{
  defineWeakSelf();
  DISPATCH_AFTER(0.1, ^{
    [weakSelf.window.rootViewController presentViewController:[ApplicationViewHierarchyHelper navigationControllerWithCreateTutorialViewController] animated:YES completion:nil];
  });
}

- (void)DEBUG_presentSettings
{
  UITabBarController *tabBarController = [TabBarHelper mainTabBarController];
  tabBarController.selectedViewController = tabBarController.viewControllers.lastObject;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  [FBAppEvents activateApp];   // Logs 'install' and 'app activate' App Events.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication]; // attempt to extract a token from the url
}

#pragma mark - Auxiliary methods

- (void)performLoginSegue
{
  if (!self.window.keyWindow) {
    [self.window makeKeyAndVisible];  // need to call this when we try to perform segue early after initialization
  }
  [[TabBarHelper mainTabBarController] performSegueWithIdentifier:@"LoginSegue" sender:nil];
}

- (void)setupTabBarActionHandling
{
  __weak typeof(self) weakSelf = self;
  self.tabBarControllerHandler = [[TabBarControllerHandler alloc] initWithCreateTutorialItemAction:^{
    [weakSelf.window.rootViewController presentViewController:[ApplicationViewHierarchyHelper navigationControllerWithCreateTutorialViewController] animated:YES completion:nil];
  }];
  
  [TabBarHelper mainTabBarController].delegate = self.tabBarControllerHandler;
}

@end
