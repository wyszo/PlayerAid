//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "AppearanceCustomizationHelper.h"
#import "CreateTutorialViewController.h"
#import "TabBarHelper.h"
#import "AuthenticationController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "UsersController.h"
#import "ServerDataUpdateController.h"
#import "ApplicationViewHierarchyHelper.h"
#import "JourneyController_Debug.h"
#import "CoreDataStackHelper.h"


@interface AppDelegate () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarControllerHandler *tabBarControllerHandler;
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [CoreDataStackHelper setupCoreDataStack];
  
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
        [[JourneyController new] performLoginSegueAnimated:NO]; // note this has to be called after setting up core data stack
      }
    }];
  }
  
  JourneyController *journeyController = [JourneyController new];
  
  if (DEBUG_MODE_FLOW_EDIT_TUTORIAL || DEBUG_MODE_FLOW_PUBLISH_TUTORIAL || DEBUG_MODE_ADD_TUTORIAL_STEPS || DEBUG_MODE_ADD_PHOTO) {
    [journeyController DEBUG_presentCreateTutorialViewController];
  }
  
  if (DEBUG_MODE_PUSH_SETTINGS) {
    [journeyController DEBUG_presentSettings];
  }
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
  defineWeakSelf();
  self.tabBarControllerHandler = [[TabBarControllerHandler alloc] initWithCreateTutorialItemAction:^{
    [weakSelf.window.rootViewController presentViewController:[ApplicationViewHierarchyHelper navigationControllerWithCreateTutorialViewController] animated:YES completion:nil];
  }];
  
  [TabBarHelper mainTabBarController].delegate = self.tabBarControllerHandler;
}

@end
