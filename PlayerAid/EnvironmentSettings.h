//
//  PlayerAid
//

@interface EnvironmentSettings : NSObject

/**
 Returns correct server URL based on current app bundle identifier
 */
- (NSString *)serverBaseURL;

/**
 Returns server public key for RSA encryption for current environment (specified via app bundle identifier)
 */
- (NSString *)serverRSAPublicKey;

@end