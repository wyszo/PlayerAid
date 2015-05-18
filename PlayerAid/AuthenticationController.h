//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AuthenticationController : NSObject
+ (FBLoginView *)facebookLoginViewWithLoginCompletion:(void (^)(id<FBGraphUser> user, NSError *error))completion;
@end
