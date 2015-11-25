//
//  PlayerAid
//

@import KZAsserts;
#import "FacebookAuthenticationController.h"
#import "NSError+PlayerAidErrors.h"

@interface FacebookAuthenticationController () <FBSDKLoginButtonDelegate>
@property (nonatomic, copy) VoidBlock loginButtonActionBlock;
@property (nonatomic, copy) void (^completionBlock)(FBSDKProfile *user, NSError *error);
@property (nonatomic, strong) FBSDKProfile *user;
@end

@implementation FacebookAuthenticationController

#pragma mark - Singleton

/* Technical debt: could easily avoid making a singleton here! */
SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - Public interface

+ (nullable FBSDKLoginButton *)facebookLoginViewWithAction:(nullable VoidBlock)action completion:(void (^)(FBSDKProfile *user, NSError *error))completion
{
  AssertTrueOrReturnNil(completion);
  [self.class setupFacebookSDKBehaviour];
  
  {
    // TODO: Technical debt - setting a completion block on a singleton?? Definitely an anti-pattern!!!
    FacebookAuthenticationController.sharedInstance.loginButtonActionBlock = action;
    FacebookAuthenticationController.sharedInstance.completionBlock = completion;
  }
  
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
  CallBlock(self.loginButtonActionBlock);
  
  if (error) {
    CallBlock(self.completionBlock, nil, error);
  }
  else {
    if ([result isCancelled]) {
      NSError *error = [NSError userCancelledURLRequestError];
      CallBlock(self.completionBlock, nil, error);
      return;
    }
    self.user = [FBSDKProfile currentProfile]; // setter should invoike completion block
    
    if (!self.user) {
      [self registerForFacebookUserProfileDidChangeNotification];
    }
  }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
  AssertTrueOrReturn(NO && @"user should not be able to logout using login button!");
}

#pragma mark - Facebook notifications

- (void)registerForFacebookUserProfileDidChangeNotification
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDidChange:) name:FBSDKProfileDidChangeNotification object:nil];
}

- (void)stopObservingFacebookProfileNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
}

#pragma mark - Setters

- (void)setUser:(FBSDKProfile *)user
{
  _user = user;
  if (user != nil) {
    CallBlock(self.completionBlock, self.user, nil);
  }
}

#pragma mark - Notification callbacks

- (void)profileDidChange:(NSNotification *)notification
{
  FBSDKProfile *user = notification.userInfo[FBSDKProfileChangeNewKey];
  AssertTrueOrReturn(user);
  
  [self stopObservingFacebookProfileNotifications];
  self.user = user; // should invoike completion block
}

@end