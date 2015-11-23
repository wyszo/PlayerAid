//
//  PlayerAid
//

@import Foundation;
@import FBSDKCoreKit;
@import FBSDKLoginKit;
#import <TWCommonLib/TWCommonMacros.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookAuthenticationController : NSObject

NEW_AND_INIT_UNAVAILABLE

+ (nullable FBSDKLoginButton *)facebookLoginViewWithLoginCompletion:(void (^)(FBSDKProfile *user, NSError *error))completion;

+ (void)logout;

@end

NS_ASSUME_NONNULL_END