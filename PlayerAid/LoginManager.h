//
//  PlayerAid
//

@interface LoginManager : NSObject

/**
 Saves the api token for further use and triggers users and tutorials data refresh.
 */
- (void)loginWithApiToken:(nonnull NSString *)apiToken completion:(nullable VoidBlockWithError)completion;

@end
