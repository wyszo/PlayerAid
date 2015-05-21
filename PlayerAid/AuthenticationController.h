//
//  PlayerAid
//


@interface AuthenticationController : NSObject

NEW_AND_INIT_UNAVAILABLE

+ (void)checkIsUserAuthenticatedPingServerCompletion:(void (^)(BOOL authenticated))completion;

@end
