//
//  PlayerAid
//

@import Fabric;
@import Crashlytics;
#import <TWCommonLib/TWMagicalRecordDebugErrorHandler.h>
#import <TWCommonLib/TWVideoPlaybackErrorHandler.h>
#import <BlocksKit/NSObject+BKAssociatedObjects.h>
#import "AppInitializer.h"
#import "JourneyController_Debug.h"
#import "AuthenticationController.h"
#import "ServerDataUpdateController.h"
#import "CoreDataStackHelper.h"
#import "DebugSettings.h"
#import "AppearanceCustomizationHelper.h"

static NSString *const AppLifetimeStaticVariable = @"Lifetime";

@implementation AppInitializer

#pragma mark - AppSetup

- (void)initializeGlobalErrorHandlers
{
  id errorHandler = [TWVideoPlaybackErrorHandler new];
  [AppLifetimeStaticVariable bk_associateValue:errorHandler withKey:@"VideoPlayback ErrorHandler"];
}

- (void)initializeFrameworks
{
  [Fabric with:@[[Crashlytics class]]];
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
  
  if (DEBUG_MODE_PUSH_EDIT_PROFILE) {
    [journeyController DEBUG_presentProfile];
  }
  
  if (DEBUG_MODE_PUSH_SETTINGS) {
    [journeyController DEBUG_presentSettings];
  }
}

@end
