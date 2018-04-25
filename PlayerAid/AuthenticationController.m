//
//  PlayerAid
//

@import KZAsserts;
#import "AuthenticationController.h"
#import "AuthenticationController_SavingToken.h"
#import "AuthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"
#import "PlayerAid-Swift.h"

static NSString const* kApiAuthenticationTokenKey = @"APIAuthenticationTokenKey";


@implementation AuthenticationController

#pragma mark - Verifying authentication state 

+ (void)checkIsUserAuthenticatedPingServerCompletion:(void (^)(BOOL authenticated))completion
{
  if (OFFLINE_DEMO_ENVIRONMENT) {
    if (completion) {
      BOOL authenticated = YES;
      completion(authenticated);
    }
    return;
  }
  
  // TODO: what if our token is valid, but Facebook token is not??
  
  NSString *apiToken = [self apiAuthenticationTokenFromUserDefaults];
  if (!apiToken.length) {
    if (completion) {
      completion(NO); // not authenticated
    }
    return;
  }
  [AuthenticatedServerCommunicationController setApiToken:apiToken];
  
  // ping server to check if token is valid
  [[AuthenticatedServerCommunicationController sharedInstance].serverCommunicationController pingWithCompletion:^(id _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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

+ (void)saveApiAuthenticationTokenToUserDefaults:(NSString *)apiToken
{
  AssertTrueOrReturn(apiToken.length);
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:apiToken forKey:(NSString *)kApiAuthenticationTokenKey];
  [userDefaults synchronize];
}

@end
