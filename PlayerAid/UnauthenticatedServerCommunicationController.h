//
//  PlayerAid
//

@import Foundation;
#import <TWCommonLib/TWCommonMacros.h>

@class AuthenticationRequestData;

typedef void (^ApiTokenRequestCompletion)( NSString * __nullable apiToken, id __nullable responseObject, NSError * __nullable error);


/**
 Allows to access those parts of our RESET API that don't require access token. HTTP cache is never used. 
 TODO: use objection for dependency injection instead of a singleton
 */
@interface UnauthenticatedServerCommunicationController : NSObject

NEW_AND_INIT_UNAVAILABLE
SHARED_INSTANCE_GENERATE_INTERFACE

/**
 Requests an API token that can be used in all communication with our PlayerAid server (via AuthenticatedServerCommunicationController class).
 */
+ (void)requestAPITokenWithAuthenticationRequestData:(nonnull AuthenticationRequestData *)data
                                          completion:(nullable void (^)(NSHTTPURLResponse * __nullable response, id __nullable responseObject, NSError * __nullable error))completion;

/**
 Requests an API token that can be used in all communication with our PlayerAid server (via AuthenticatedServerCommunicationController class).
 */
- (void)loginWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable ApiTokenRequestCompletion)completion;

- (void)signUpWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable ApiTokenRequestCompletion)completion;

@end


// Helper class to deliver request parameters
@interface AuthenticationRequestData : NSObject

@property (nonatomic, copy, nullable) NSString *facebookAuthenticationToken;
@property (nonatomic, copy, nullable) NSString *email;

@end
