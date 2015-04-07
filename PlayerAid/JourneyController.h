//
//  PlayerAid
//

@interface JourneyController : NSObject

/**
 Can be called from anywhere within the app, since the segue is from rootViewController. Doesn't clear any app data, just performs segue. 
 */
- (void)performLoginSegueAnimated:(BOOL)animated;

/**
 Clears app data and closes active Facebook session
 */
- (void)clearAppDataAndPerformLoginSegueAnimated:(BOOL)animated;

@end
