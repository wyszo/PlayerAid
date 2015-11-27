//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "FacebookAuthenticationController.h"
#import "NSError+PlayerAidErrors.h"
#import "FBGraphApiRequest.h"

@interface FacebookAuthenticationController () <FBSDKLoginButtonDelegate>
@property (nonatomic, copy) VoidBlock loginButtonActionBlock;
@property (nonatomic, copy) ProfileRequestCompletionBlock completionBlock;
@property (nonatomic, strong) FBGraphApiRequest *graphApiRequest;

@end

@implementation FacebookAuthenticationController

#pragma mark - Public interface

- (nullable FBSDKLoginButton *)facebookLoginViewWithAction:(nullable VoidBlock)action completion:(ProfileRequestCompletionBlock)completion
{
  AssertTrueOrReturnNil(completion);
  [self.class setupFacebookSDKBehaviour];
  
  self.loginButtonActionBlock = action;
  self.completionBlock = completion;
  
  FBSDKLoginButton *loginButton = [FBSDKLoginButton new];
  loginButton.readPermissions = @[@"public_profile", @"email"];
  loginButton.delegate = self;
  return loginButton;
}

+ (void)setupFacebookSDKBehaviour
{
  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

- (void)logout
{
  [FBSDKAccessToken setCurrentAccessToken:nil];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
  CallBlock(self.loginButtonActionBlock);
  
  if (error) {
    CallBlock(self.completionBlock, nil, nil, error);
  }
  else {
    if ([result isCancelled]) {
      NSError *error = [NSError userCancelledURLRequestError];
      CallBlock(self.completionBlock, nil, nil, error);
      return;
    }
    
    defineWeakSelf();
    self.graphApiRequest = [[FBGraphApiRequest alloc] init];
    [self.graphApiRequest makeGraphApiProfileRequestWithCompletion:^(FBSDKProfile * _Nullable profile, NSString * _Nullable email, NSError * _Nullable error) {
      if (error) {
        [weakSelf logout];
      }
      weakSelf.completionBlock(profile, email, error);
    }];
  }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
  AssertTrueOrReturn(NO && @"user should not be able to logout using login button!");
}

@end