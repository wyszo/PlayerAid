//
//  PlayerAid
//

@interface EnvironmentSettings : NSObject

/**
 Returns correct server URL based on current app bundle identifier
 */
- (NSString *)serverBaseURL;

@end