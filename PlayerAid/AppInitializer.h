//
//  PlayerAid
//

@import Foundation;

@interface AppInitializer : NSObject

- (void)initializeAppInternals;
- (void)customizeAppAppearance;

// TODO: this logic should not be part of the initializer
- (void)applicationLaunchFetchUsersAndTutorials;
- (void)offlineDemoShowLogin;

@end
