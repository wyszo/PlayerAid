//
//  PlayerAid
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AppInitializer.h"
#import "JourneyController_Debug.h"
#import "AuthenticationController.h"
#import "ServerDataUpdateController.h"
#import "CoreDataStackHelper.h"
#import "AppearanceCustomizationHelper.h"


@implementation AppInitializer

#pragma mark - AppSetup

- (void)initializeFrameworks
{
  [Fabric with:@[[Crashlytics class]]];
}

- (void)initializeCoreData
{
  [CoreDataStackHelper setupCoreDataStack];
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
