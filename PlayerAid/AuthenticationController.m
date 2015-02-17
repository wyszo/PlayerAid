//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import "AuthenticationController.h"


@implementation AuthenticationController

#pragma mark - Verifying authentication state 

+ (BOOL)checkIsUserAuthenticatedPingServer
{
  // TODO: 1. check if user logged in to Facebook (do we need that?). Probably we don't if we already have our internal token. But still - maybe we need to check it anyway??
  
  // TODO: 2. check if our API token is valid - send a ping network request
  
  return NO;
}

@end
