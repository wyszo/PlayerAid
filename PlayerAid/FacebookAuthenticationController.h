//
//  PlayerAid
//

@import Foundation;
@import FBSDKCoreKit;
@import FBSDKLoginKit;
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWCommonTypes.h>
#import "FBGraphAPIRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacebookAuthenticationController : NSObject

- (nullable FBSDKLoginButton *)facebookLoginViewWithAction:(nullable VoidBlock)action completion:(ProfileRequestCompletionBlock)completion;
- (void)logout;

@end

NS_ASSUME_NONNULL_END