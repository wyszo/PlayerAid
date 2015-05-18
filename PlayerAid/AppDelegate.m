//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <MagicalRecord+Setup.h>
#import <KZAsserts.h>
#import "AppDelegate.h"
#import "DataModelMock.h"
#import "AppearanceCustomizationHelper.h"


@interface AppDelegate ()
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"PlayerAidStore"];
  [[AppearanceCustomizationHelper new] customizeApplicationAppearance];
  [self populateCoreDataWithSampleEntities];
  return YES;
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
