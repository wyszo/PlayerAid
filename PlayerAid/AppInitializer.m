//
//  PlayerAid
//

@import Fabric;
@import Crashlytics;
@import KZPropertyMapper;
@import TWCommonLib;
#import <BlocksKit/NSObject+BKAssociatedObjects.h>
#import "AppInitializer.h"
#import "JourneyController_Debug.h"
#import "AuthenticationController.h"
#import "ServerDataUpdateController.h"
#import "CoreDataStackHelper.h"
#import "DebugSettings.h"
#import "GlobalSettings.h"
#import "AppearanceCustomizationHelper.h"

static NSString *const AppLifetimeStaticVariable = @"Lifetime";

@implementation AppInitializer

#pragma mark - AppSetup

- (void)initializeAppInternals
{
  [self initializeGlobalErrorHandlers];
  [self increaseCacheSize];
  [self initializeFrameworks];
  [self initializeCoreData];
}

- (void)initializeGlobalErrorHandlers
{
  id errorHandler = [TWVideoPlaybackErrorHandler new];
  [AppLifetimeStaticVariable bk_associateValue:errorHandler withKey:@"VideoPlayback ErrorHandler"];
}

- (void)increaseCacheSize
{
  // Default cache size: in-memory: 0,5MB; disk: 10MB
  [NSURLCache tw_setMemoryCacheSizeMegabytes:10.0 diskCacheSizeMegabytes:50.0];
}

- (void)initializeFrameworks
{
#if DEBUG == 0 // not defined or disabled
  [Fabric with:@[[Crashlytics class]]];
#endif

  [KZPropertyMapper logIgnoredValues:NO];
}

- (void)initializeCoreData
{
  [CoreDataStackHelper setupCoreDataStack];
  
  id errorHandler = [TWMagicalRecordDebugErrorHandler new];
  [AppLifetimeStaticVariable bk_associateValue:errorHandler withKey:@"CoreData ErrorHandler"];
}

- (void)customizeAppAppearance
{
  [[AppearanceCustomizationHelper new] customizeApplicationAppearance];
}

#pragma mark - AppLaunchDataFetch

- (void)offlineDemoShowLogin {
  if (OFFLINE_DEMO_ENVIRONMENT) {
    [[JourneyController new] performLoginSegueAnimated:NO];
  }
}

- (void)applicationLaunchFetchUsersAndTutorials
{
  if (!DEBUG_OFFLINE_MODE && !OFFLINE_DEMO_ENVIRONMENT) {
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
  
  if (DEBUG_MODE_FLOW_EDIT_TUTORIAL || DEBUG_MODE_FLOW_PUBLISH_TUTORIAL) {
    [journeyController DEBUG_presentCreateTutorialViewController];
  }
  
  if (DEBUG_MODE_PUSH_EDIT_PROFILE) {
    [journeyController DEBUG_presentProfile];
  }
  
  if (DEBUG_MODE_PUSH_SETTINGS) {
    [journeyController DEBUG_presentSettings];
  }
}

@end
