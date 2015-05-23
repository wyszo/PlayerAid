//
//  PlayerAid
//

#import "Tutorial.h"


typedef void (^NetworkResponseBlock)(NSHTTPURLResponse *response, id responseObject, NSError *error);


/**
 A wrapper to network requests to our server - if access token is not set, requests will fail (assert)!
 */
@interface AuthenticatedServerCommunicationController : NSObject

+ (instancetype)sharedInstance;
+ (void)setApiToken:(NSString *)apiToken;


- (void)pingCompletion:(NetworkResponseBlock)completion;
- (void)getUserCompletion:(NetworkResponseBlock)completion;
- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion;

@end
