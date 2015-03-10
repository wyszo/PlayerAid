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
- (void)getCurrentUserCompletion:(NetworkResponseBlock)completion;
- (void)getUserWithID:(NSString *)userID completion:(NetworkResponseBlock)completion;
- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion;

// publishing tutorial
- (void)createTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)submitImageForTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;

@end
