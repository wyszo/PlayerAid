//
//  PlayerAid
//

#import "AuthenticationController.h"


@interface AuthenticationController (SavingToken)

+ (void)saveApiAuthenticationTokenToUserDefaults:(NSString *)apiToken;

@end
