//
//  PlayerAid
//

@import Foundation;

@interface AppInitializer : NSObject

- (void)initializeGlobalErrorHandlers;
- (void)initializeFrameworks;
- (void)initializeCoreData;
- (void)customizeAppAppearance;

- (void)applicationLaunchDataFetch;

@end
