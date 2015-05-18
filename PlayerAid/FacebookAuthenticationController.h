//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookAuthenticationController : NSObject

- (id)init __unavailable;
+ (id)new __unavailable;

+ (FBLoginView *)facebookLoginViewWithLoginCompletion:(void (^)(id<FBGraphUser> user, NSError *error))completion;

@end
