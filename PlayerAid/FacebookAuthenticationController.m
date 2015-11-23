//
//  PlayerAid
//

@import KZAsserts;
#import "FacebookAuthenticationController.h"

@interface FacebookAuthenticationController () <FBSDKLoginButtonDelegate>
@property (nonatomic, copy) void (^completionBlock)(FBSDKProfile *user, NSError *error);
@property (nonatomic, strong) FBSDKProfile *user;
@end

@implementation FacebookAuthenticationController

#pragma mark - Singleton

/* Technical debt: could easily avoid making a singleton here! */
SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - Public interface

+ (nullable FBSDKLoginButton *)facebookLoginViewWithLoginCompletion:(void (^)(FBSDKProfile *user, NSError *error))completion
{
  AssertTrueOrReturnNil(completion);
  [self.class setupFacebookSDKBehaviour];
  
  ((FacebookAuthenticationController *)self.sharedInstance).completionBlock = completion;
  
  FBSDKLoginButton *loginButton = [FBSDKLoginButton new];
  loginButton.readPermissions = @[@"email"];
  loginButton.delegate = self.sharedInstance;
  return loginButton;
}

+ (void)setupFacebookSDKBehaviour
{
  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

+ (void)logout
{
  FacebookAuthenticationController.sharedInstance.user = nil;
  [FBSDKAccessToken setCurrentAccessToken:nil];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
  if (error) {
    CallBlock(self.completionBlock, nil, error);
  }
  else {
    if ([result isCancelled]) {
      return;
    }
    
    // TODO: that's too early, profile data not fetched yet...
    self.user = [FBSDKProfile currentProfile];
    AssertTrueOrReturn(self.user);
    // TODO: Investigate - I got email premission declined from my test account here (in result.declinedPermissions)!
    
    CallBlock(self.completionBlock, self.user, nil);
  }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
  AssertTrueOrReturn(NO && @"user should not be able to logout using login button!");
}

@end