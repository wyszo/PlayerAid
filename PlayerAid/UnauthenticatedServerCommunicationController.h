//
//  PlayerAid
//

@class AuthenticationRequestData;


/**
 Allows to access those parts of our RESET API that don't require access token. HTTP cache is never used. 
 */
@interface UnauthenticatedServerCommunicationController : NSObject

/**
 Requests an API token that can be used in all communication with our PlayerAid server (via AuthenticatedServerCommunicationController class).
 */
+ (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, id responseObject, NSError *error))completion;

@end


// Helper class to deliver request parameters
@interface AuthenticationRequestData : NSObject

@property (nonatomic, copy) NSString *facebookAuthenticationToken;
@property (nonatomic, copy) NSString *email;

@end
