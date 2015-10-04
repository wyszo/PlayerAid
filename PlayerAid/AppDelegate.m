//
//  PlayerAid
//

@import FacebookSDK;
#import "AppDelegate.h"
#import "CreateTutorialViewController.h"
#import "TabBarHelper.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "ApplicationViewHierarchyHelper.h"
#import "AppInitializer.h"

@interface AppDelegate () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarControllerHandler *tabBarControllerHandler;
@property (strong, nonatomic) AppInitializer *appInitializer;
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  
  self.appInitializer = [AppInitializer new];
  [self.appInitializer initializeFrameworks];
  [self.appInitializer initializeCoreData];
  [self.appInitializer applicationLaunchDataFetch];
  [self.appInitializer customizeAppAppearance];
  
  [self setupTabBarActionHandling];
  
  return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [self.appInitializer applicationLaunchDataFetch];
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

- (void)setupTabBarActionHandling
{
  self.tabBarControllerHandler = [[TabBarControllerHandler alloc] initWithCreateTutorialItemAction:^{
    [ApplicationViewHierarchyHelper presentModalCreateTutorialViewController];
  }];
  [TabBarHelper mainTabBarController].delegate = self.tabBarControllerHandler;
}

@end
