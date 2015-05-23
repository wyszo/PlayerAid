//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>


@interface FacebookAuthenticationController : NSObject

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

+ (FBLoginView *)facebookLoginViewWithLoginCompletion:(void (^)(id<FBGraphUser> user, NSError *error))completion;

@end
