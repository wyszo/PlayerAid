//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <MagicalRecord+Setup.h>
#import "AppDelegate.h"
#import "DataModelMock.h"
#import "AppearanceCustomizationHelper.h"
#import "TabBarControllerHandler.h"
#import "CreateTutorialViewController.h"
#import "ApplicationViewHierarchyHelper.h"
#import "AuthenticationController.h"
#import "NavigationControllerWhiteStatusbar.h"
#import "UsersController.h"
#import "ServerDataFetchController.h"


@interface AppDelegate () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarControllerHandler *tabBarControllerHandler;
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"PlayerAidStore"];
  [self populateCoreDataWithSampleEntities];
  
  [AuthenticationController checkIsUserAuthenticatedPingServerCompletion:^(BOOL authenticated) {
    if (authenticated) {
      [ServerDataFetchController updateUserAndTutorials];
    }
    else {
      [self performLoginSegue]; // note this has to be called after setting up core data stack
    }
  }];
  
  [[AppearanceCustomizationHelper new] customizeApplicationAppearance];
  [self setupTabBarActionHandling];
  
  return YES;
}

- (void)performLoginSegue
{
  if (!self.window.keyWindow) {
    [self.window makeKeyAndVisible];  // need to call this when we try to perform segue early after initialization
  }
  [[ApplicationViewHierarchyHelper mainTabBarController] performSegueWithIdentifier:@"LoginSegue" sender:nil];
}

- (void)setupTabBarActionHandling
{
  __weak typeof(self) weakSelf = self;
  self.tabBarControllerHandler = [[TabBarControllerHandler alloc] initWithCreateTutorialItemAction:^{
    
    CreateTutorialViewController *createTutorialViewController = [[CreateTutorialViewController alloc] initWithNibName:@"CreateTutorialView" bundle:[NSBundle mainBundle]];
    NavigationControllerWhiteStatusbar *navigationController = [[NavigationControllerWhiteStatusbar alloc] initWithRootViewController:createTutorialViewController];
    
    [weakSelf.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
  }];
  
  [ApplicationViewHierarchyHelper mainTabBarController].delegate = self.tabBarControllerHandler;
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

#pragma mark - Other

- (void)populateCoreDataWithSampleEntities
{
  // TODO: switch to client-server communication to populate database
  [[DataModelMock new] addDummyTutorialUserAndSectionObjects];
}

@end
