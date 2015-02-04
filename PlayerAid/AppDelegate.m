//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <MagicalRecord+Setup.h>
#import <KZAsserts.h>
#import "AppDelegate.h"
#import "DataModelMock.h"

@interface AppDelegate ()
@end


@implementation AppDelegate

#pragma mark - delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBLoginView class]; // ensures FBLoginView is loaded in memory before being presented, recommended by Facebook
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"PlayerAidStore"];
  [self customiseAppearance];
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

- (void)customiseAppearance
{
  // White fonts in statusbar and Navigation bars
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
  
  // Tabbar customisation
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor greenColor] }  forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateSelected];
  
  // TabBar background color
  [[UITabBar appearance] setBarTintColor:[UIColor yellowColor]];
  
  [self customiseCreateTabBarButtonBackground];
 
  // TODO: change TabBar border line color
}

- (void)customiseCreateTabBarButtonBackground
{
  AssertTrueOrReturn([self.window.rootViewController isKindOfClass:[UITabBarController class]]);
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  
  const NSUInteger createItemIndex = 2;
  AssertTrueOrReturn(tabBarController.tabBar.items.count > createItemIndex);
  
  UIColor *createButtonBackgroundColor = [UIColor colorWithRed:1.00 green:0.07 blue:0.7 alpha:1.0];
  
  UITabBar *tabBar = tabBarController.tabBar;
  CGFloat tabbarItemWidth = tabBar.frame.size.width / (CGFloat)tabBar.items.count;
  UIView *createButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(tabbarItemWidth * createItemIndex, 0, tabbarItemWidth, tabBar.frame.size.height)];
  createButtonBackgroundView.backgroundColor = createButtonBackgroundColor;
  
  [tabBar insertSubview:createButtonBackgroundView atIndex:0];
}

- (void)populateCoreDataWithSampleEntities
{
  // TODO: switch to client-server communication to populate database
  [[DataModelMock new] addDummyTutorialObjects];
}

@end
