//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>


@interface FacebookAuthenticationController : NSObject

NEW_AND_INIT_UNAVAILABLE

+ (FBLoginView *)facebookLoginViewWithLoginCompletion:(void (^)(id<FBGraphUser> user, NSError *error))completion;

+ (void)logout;

@end
