//
//  PlayerAid
//

@import Foundation;
@import FBSDKCoreKit;
@import FBSDKLoginKit;
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWCommonTypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookAuthenticationController : NSObject

/**
 Technical debt: this class should not be a singleton!
 */
NEW_AND_INIT_UNAVAILABLE
SHARED_INSTANCE_GENERATE_INTERFACE

+ (nullable FBSDKLoginButton *)facebookLoginViewWithAction:(nullable VoidBlock)action completion:(void (^)(FBSDKProfile *user, NSString *email, NSError *error))completion;

- (void)logout;

@end

NS_ASSUME_NONNULL_END