//
//  PlayerAid
//

@import Foundation;

@interface LoginManager : NSObject

/**
 Saves the api token for further use and triggers users and tutorials data refresh.
 TODO: Technical debt: we shouldn't set if user is linked with facebook at this point!
 */
- (void)loginWithApiToken:(nonnull NSString *)apiToken userLinkedWithFacebook:(BOOL)linkedWithFacebook completion:(nullable VoidBlockWithError)completion;

@end
