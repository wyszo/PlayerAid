//
//  PlayerAid
//

@class AuthenticationRequestData;

typedef void (^ApiTokenRequestCompletion)( NSString * __nullable apiToken,  NSError * __nullable error);


/**
 Allows to access those parts of our RESET API that don't require access token. HTTP cache is never used. 
 */
@interface UnauthenticatedServerCommunicationController : NSObject

/**
 Requests an API token that can be used in all communication with our PlayerAid server (via AuthenticatedServerCommunicationController class).
 */
+ (void)requestAPITokenWithAuthenticationRequestData:(nonnull AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, id responseObject, NSError *error))completion;

/**
 Requests an API token that can be used in all communication with our PlayerAid server (via AuthenticatedServerCommunicationController class).
 */
+ (void)requestAPITokenWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable ApiTokenRequestCompletion)completion;

@end


// Helper class to deliver request parameters
@interface AuthenticationRequestData : NSObject

@property (nonatomic, copy, nullable) NSString *facebookAuthenticationToken;
@property (nonatomic, copy, nullable) NSString *email;

@end
