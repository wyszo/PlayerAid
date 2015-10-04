//
//  PlayerAid
//

@import Foundation;

@interface EnvironmentSettings : NSObject

/**
 Returns correct server URL based on current app bundle identifier
 */
- (nonnull NSString *)serverBaseURL;

/**
 Returns local path to the server certificate containing RSA public keys for current environment (specified via app bundel identifier)
 */
- (nullable NSString *)serverRSACertificatePath;

@end
