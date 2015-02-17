//
//  PlayerAid
//

#import <Foundation/Foundation.h>


@interface AuthenticationController : NSObject

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

+ (BOOL)checkIsUserAuthenticatedPingServer;

@end
