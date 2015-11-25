//
//  PlayerAid
//

@import FBSDKLoginKit;
#import <TWCommonLib/TWCommonMacros.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookLoginControlsFactory : NSObject

NEW_AND_INIT_UNAVAILABLE

/**
 Returns a Facebook login button, which when user authenticates, triggers internal PlayerAid authentication. Network traffic and error handling are done automatically, you don't need to perform any additional error checking.
 
 @param butotnAction  Will be invoked instantly after pressing a button
 @param completion  Completion block invoked only when user successfully authenticated to both Facebook and to our server. If authentication was unsuccessful, callback won't ever be called (no need, because all error handling is done internally). If successful - our internal API token is returned (used in authentication field for all subsequent requests to PlayerAid server).
 */
+ (nullable FBSDKLoginButton *)facebookLoginButtonTriggeringInternalAuthenticationWithAction:(nullable VoidBlock)buttonAction completion:(void (^)(NSString *apiToken, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END