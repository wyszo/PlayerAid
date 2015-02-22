//
//  PlayerAid
//

#import "Tutorial.h"


/**
 A wrapper to network requests to our server - if access token is not set, requests will fail (assert)!
 */
@interface AuthenticatedServerCommunicationController : NSObject

+ (instancetype)sharedInstance;
+ (void)setApiToken:(NSString *)apiToken;


- (void)pingCompletion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion;
- (void)postUserCompletion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion;
- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion;

@end



