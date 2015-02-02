//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>
#import "FacebookAuthenticationController.h"

@interface AuthenticationController : NSObject

- (id)init __unavailable;
+ (id)new __unavailable;

/** 
 Returns a Facebook login button, which when user authenticates, triggers internal PlayerAid authentication. Network traffic and error handling are done automatically, you don't need to perform any additional error checking.
 
 @param completion   
      Completion block invoked only when user successfully authenticated to both Facebook and to our server. If authentication was unsuccessful, callback won't ever be called (no need, because all error handling is done internally).
 */
+ (FBLoginView *)facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:(void (^)(NSError *error))completion;

@end
