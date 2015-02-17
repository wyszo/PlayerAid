//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import "AuthenticationController.h"
#import "ServerCommunicationController.h"


static NSString const* kApiAuthenticationTokenKey = @"APIAuthenticationTokenKey";


@implementation AuthenticationController

#pragma mark - Verifying authentication state 

+ (void)checkIsUserAuthenticatedPingServerCompletion:(void (^)(BOOL authenticated))completion
{
  // TODO: what if our token is valid, but Facebook token is not??
  
  NSString *apiToken = [self apiAuthenticationTokenFromUserDefaults];
  if (!apiToken.length) {
    if (completion) {
      completion(NO); // not authenticated
    }
    return;
  }
  
  // ping server to check if token is valid
  [[ServerCommunicationController sharedInstance] pingWithApiToken:apiToken completion:^(NSError *error) {
    if (completion) {
      // TODO: handle various types of errors
      BOOL authenticated = (error == nil);
      completion(authenticated);
    }
  }];
}

#pragma mark - API Authentication Token

+ (NSString *)apiAuthenticationTokenFromUserDefaults
{
  return [[NSUserDefaults standardUserDefaults] stringForKey:(NSString *)kApiAuthenticationTokenKey];
}

@end
