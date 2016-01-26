//
//  PlayerAid
//

@import FBSDKCoreKit;
#import "AppDelegate.h"
#import "CreateTutorialViewController.h"
#import "TabBarHelper.h"
#import "ApplicationViewHierarchyHelper.h"
#import "AppInitializer.h"

@interface AppDelegate () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarControllerHandler *tabBarControllerHandler;
@property (strong, nonatomic) AppInitializer *appInitializer;
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  
  self.appInitializer = [AppInitializer new];
  [self.appInitializer initializeAppInternals];
  [self.appInitializer applicationLaunchFetchUsersAndTutorials];
  [self.appInitializer customizeAppAppearance];
  
  [self setupTabBarActionHandling];
  
  return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [self.appInitializer applicationLaunchFetchUsersAndTutorials];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];   // Logs 'install' and 'app activate' App Events.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - Auxiliary methods

- (void)setupTabBarActionHandling {
  self.tabBarControllerHandler = [[TabBarControllerHandler alloc] initWithCreateTutorialItemAction:^{
    [ApplicationViewHierarchyHelper presentModalCreateTutorialViewController];
  }];
  [TabBarHelper mainTabBarController].delegate = self.tabBarControllerHandler;
}

@end
