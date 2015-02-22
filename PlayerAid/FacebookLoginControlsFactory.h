//
//  PlayerAid
//

#import <FacebookSDK.h>


@interface FacebookLoginControlsFactory : NSObject

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

/**
 Returns a Facebook login button, which when user authenticates, triggers internal PlayerAid authentication. Network traffic and error handling are done automatically, you don't need to perform any additional error checking.
 
 @param completion
 Completion block invoked only when user successfully authenticated to both Facebook and to our server. If authentication was unsuccessful, callback won't ever be called (no need, because all error handling is done internally). If successful - our internal API token is returned (used in authentication field for all subsequent requests to PlayerAid server).
 */
+ (FBLoginView *)facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:(void (^)(NSString *apiToken, NSError *error))completion;

@end
