//
//  PlayerAid
//

#import "Tutorial.h"

@class AuthenticationRequestData;

// A wrapper to network requests to our server
@interface ServerCommunicationController : NSObject

+ (ServerCommunicationController *)sharedInstance;

/**
 Requests an API token that can be used in all communication with our PlayerAid server.
 */
- (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion;

- (void)pingWithApiToken:(NSString *)apiToken completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion;

- (void)postUserWithApiToken:(NSString *)apiToken completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion;

- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion;

@end


// Helper class to deliver request parameters
@interface AuthenticationRequestData : NSObject

@property (nonatomic, copy) NSString *facebookAuthenticationToken;
@property (nonatomic, copy) NSString *email;

@end
