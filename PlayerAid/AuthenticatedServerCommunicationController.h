//
//  PlayerAid
//

@import Foundation;
#import "Tutorial.h"
#import "TutorialComment.h"
#import "User.h"
#import <TWCommonLib/TWCommonTypes.h>

typedef void (^NetworkResponseBlock)(NSHTTPURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error);

@class ServerCommunicationController;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is Deprecated and intended to no longer be extended. Implement new network requests in ServerCommunicationController.swift
 
 A wrapper to network requests to our server - if access token is not set, requests will fail (assert)!
 TODO: decompose it into a couple of smaller objects!
 */
DEPRECATED_ATTRIBUTE // try to use ServerCommunicationController instead!
@interface AuthenticatedServerCommunicationController : NSObject

+ (instancetype)sharedInstance;
+ (void)setApiToken:(NSString *)apiToken;

@property (nonatomic, strong, readonly) ServerCommunicationController *serverCommunicationController;

- (void)pingCompletion:(NetworkResponseBlock)completion;
- (void)getCurrentUserCompletion:(NetworkResponseBlock)completion;
- (void)getUserWithID:(NSString *)userID completion:(NetworkResponseBlock)completion;

// tutorials
- (void)deleteTutorial:(Tutorial *)tutorial completion:(nullable VoidBlockWithError)completion;
- (void)listTutorialsWithCompletion:(NetworkResponseBlock)completion;
- (void)likeTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)unlikeTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)reportTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)refreshTutorialAndComments:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;

// comments
- (void)addAComment:(NSString *)commentText toTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)editComment:(TutorialComment *)comment withText:(NSString *)commentText completion:(NetworkResponseBlock)completion;
- (void)deleteComment:(TutorialComment *)comment completion:(NetworkResponseBlock)completion;
- (void)reportCommentAsInappropriate:(TutorialComment *)comment completion:(NetworkResponseBlock)completion;

// publishing tutorial
- (void)createTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
- (void)submitImageForTutorial:(Tutorial *)tutorial completion:(nullable NetworkResponseBlock)completion;
- (void)submitTutorialStep:(TutorialStep *)tutorialStep withPosition:(NSInteger)position completion:( NetworkResponseBlock)completion;
- (void)submitTutorialForReview:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;

// edit profile
- (void)updateUserAvatarFromFacebookWithAccessToken:(NSString *)facebookToken completion:( NetworkResponseBlock)completion;
- (void)saveUserProfileWithName:(NSString *)userName description:(nullable NSString *)userDescription completion:(NetworkResponseBlock)completion;
- (void)saveUserAvatarPicture:(UIImage *)image completion:(nullable NetworkResponseBlock)completion;

// users
- (void)followUser:(User *)user completion:(NetworkResponseBlock)completion;
- (void)unfollowUser:(User *)user completion:(NetworkResponseBlock)completion;

@end

NS_ASSUME_NONNULL_END