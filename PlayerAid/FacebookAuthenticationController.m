//
//  PlayerAid
//

@import KZAsserts;
@import AFNetworking;
#import "FacebookAuthenticationController.h"
#import "NSError+PlayerAidErrors.h"

@interface FacebookAuthenticationController () <FBSDKLoginButtonDelegate>
@property (nonatomic, copy) VoidBlock loginButtonActionBlock;
@property (nonatomic, copy) void (^completionBlock)(FBSDKProfile *user, NSError *error);
@property (nonatomic, strong) FBSDKProfile *user;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
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
  
  // TODO: Technical debt - setting a completion block on a singleton?? Definitely an anti-pattern!!!
  FacebookAuthenticationController.sharedInstance.loginButtonActionBlock = action;
  FacebookAuthenticationController.sharedInstance.completionBlock = completion;
  
  FBSDKLoginButton *loginButton = [FBSDKLoginButton new];
  loginButton.readPermissions = @[@"email"];
  loginButton.delegate = self.sharedInstance;
  return loginButton;
}

+ (void)setupFacebookSDKBehaviour
{
  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

- (void)logout
{
  self.user = nil;
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
      [self startObservingFacebookProfileUpdates];
    }
  }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
  AssertTrueOrReturn(NO && @"user should not be able to logout using login button!");
}

#pragma mark - Reachability monitoring 

- (void)startMonitoringReachability
{
  defineWeakSelf();
  
  self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"www.facebook.com"];
  AssertTrueOrReturn(self.reachabilityManager);
  
  [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    if (status == AFNetworkReachabilityStatusNotReachable) {
      [FacebookAuthenticationController.sharedInstance logout];
      [weakSelf stopObservingFacebookProfileUpdates];
      
      NSError *error = [NSError networkConnectionLostError];
      CallBlock(weakSelf.completionBlock, nil, error);
    }
  }];
  [self.reachabilityManager startMonitoring];
}

- (void)stopMonitoringReachability
{
  [self.reachabilityManager setReachabilityStatusChangeBlock:nil];
  [self.reachabilityManager stopMonitoring];
}

#pragma mark - Facebook notifications

- (void)startObservingFacebookProfileUpdates
{
  [self startMonitoringReachability];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDidChange:) name:FBSDKProfileDidChangeNotification object:nil];
}

- (void)stopObservingFacebookProfileUpdates
{
  [self stopMonitoringReachability];
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
  
  [self stopObservingFacebookProfileUpdates];
  self.user = user; // should invoike completion block
}

@end