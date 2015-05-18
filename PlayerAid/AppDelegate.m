//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface AppDelegate ()
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [self customiseAppearance];
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

- (void)customiseAppearance
{
  // White fonts in statusbar and Navigation bars
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

@end
