//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface AppDelegate ()
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBAppEvents activateApp];   // Logs 'install' and 'app activate' App Events.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  
  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication]; // attempt to extract a token from the url
}

@end
