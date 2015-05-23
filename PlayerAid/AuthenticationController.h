//
//  PlayerAid
//


@interface AuthenticationController : NSObject

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

+ (void)checkIsUserAuthenticatedPingServerCompletion:(void (^)(BOOL authenticated))completion;

@end
