//
//  PlayerAid
//

@import Foundation;
#import "Tutorial.h"
#import "User.h"
#import <TWCommonLib/TWCommonTypes.h>

typedef void (^NetworkResponseBlock)(NSHTTPURLResponse *response, id responseObject, NSError *error);

/**
 A wrapper to network requests to our server - if access token is not set, requests will fail (assert)!
 TODO: decompose it into a couple of smaller objects!
 */
@interface AuthenticatedServerCommunicationController : NSObject

+ (instancetype)sharedInstance;
+ (void)setApiToken:(NSString *)apiToken;


- (void)pingCompletion:(NetworkResponseBlock)completion;
- (void)getCurrentUserCompletion:(NetworkResponseBlock)completion;
- (void)getUserWithID:(NSString *)userID completion:(NetworkResponseBlock)completion;
- (void)deleteTutorial:(Tutorial *)tutorial completion:(VoidBlockWithError)completion;
- (void)listTutorialsWithCompletion:(NetworkResponseBlock)completion;
- (void)likeTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)unlikeTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;;
- (void)reportTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;

// publishing tutorial
- (void)createTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)submitImageForTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)submitTutorialStep:(TutorialStep *)tutorialStep withPosition:(NSInteger)position completion:(NetworkResponseBlock)completion;
- (void)submitTutorialForReview:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;

// edit profile
- (void)updateUserAvatarFromFacebookWithAccessToken:(NSString *)facebookToken completion:(NetworkResponseBlock)completion;
- (void)saveUserProfileWithName:(NSString *)userName description:(NSString *)userDescription completion:(NetworkResponseBlock)completion;
- (void)saveUserAvatarPicture:(UIImage *)image completion:(NetworkResponseBlock)completion;

// users
- (void)followUser:(User *)user completion:(NetworkResponseBlock)completion;
- (void)unfollowUser:(User *)user completion:(NetworkResponseBlock)completion;

@end
