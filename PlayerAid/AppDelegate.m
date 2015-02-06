//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <MagicalRecord+Setup.h>
#import <KZAsserts.h>
#import "AppDelegate.h"
#import "DataModelMock.h"
#import "AppearanceCustomizationHelper.h"
#import "TabBarControllerHandler.h"


@interface AppDelegate () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarControllerHandler *tabBarControllerHandler;
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"PlayerAidStore"];
  [[AppearanceCustomizationHelper new] customizeApplicationAppearance];
  [self populateCoreDataWithSampleEntities];
  [self setupTabBarActionHandling];
  return YES;
}

- (void)setupTabBarActionHandling
{
  __weak typeof(self) weakSelf = self;
  self.tabBarControllerHandler = [[TabBarControllerHandler alloc] initWithCreateTutorialItemAction:^{
    UIViewController *modalViewController = [[UIViewController alloc] init]; // TODO: init from xib
    modalViewController.view.backgroundColor = [UIColor whiteColor];
    [weakSelf.window.rootViewController presentViewController:modalViewController animated:YES completion:nil];
  }];
  
  UIViewController *rootViewController = self.window.rootViewController;
  AssertTrueOrReturn([rootViewController isKindOfClass:[UITabBarController class]]);
  ((UITabBarController *)rootViewController).delegate = self.tabBarControllerHandler;
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
  [[DataModelMock new] addDummyTutorialAndUserObjects];
}

@end
