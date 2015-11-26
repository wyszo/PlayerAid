//
//  PlayerAid
//

@import KZAsserts;
@import AFNetworking;
#import "FacebookAuthenticationController.h"
#import "NSError+PlayerAidErrors.h"

static const NSTimeInterval kProfileUpdateTimeoutInSeconds = 30.0f;

@interface FacebookAuthenticationController () <FBSDKLoginButtonDelegate>
@property (nonatomic, copy) VoidBlock loginButtonActionBlock;
@property (nonatomic, copy) void (^completionBlock)(FBSDKProfile *user, NSError *error);
@property (nonatomic, strong) FBSDKProfile *user;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@property (nonatomic, strong) NSTimer *timeoutTimer; // Timeout timer is useful for a case where there is a flaky internet connection that loses packets and doesn't allow to fetch data (but is not completely down)
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
  loginButton.readPermissions = @[@"public_profile", @"email"];
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
  [self scheduleTimeoutTimer];
  [self startMonitoringReachability];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDidChange:) name:FBSDKProfileDidChangeNotification object:nil];
}

- (void)stopObservingFacebookProfileUpdates
{
  [self stopTimeoutTimer];
  [self stopMonitoringReachability];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
}

#pragma mark - Timeout timer

- (void)scheduleTimeoutTimer
{
  self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kProfileUpdateTimeoutInSeconds target:self selector:@selector(timeoutTimerDidFire:) userInfo:nil repeats:NO];
}

- (void)stopTimeoutTimer
{
  [self.timeoutTimer invalidate];
  self.timeoutTimer = nil;
}

- (void)timeoutTimerDidFire:(NSTimer *)timer
{
  AssertTrueOrReturn(timer == self.timeoutTimer);
  [self stopTimeoutTimer];
  [self stopObservingFacebookProfileUpdates];
  [FacebookAuthenticationController.sharedInstance logout]; // in case we got logged in but didn't fetch user profile
  
  NSError *error = [NSError networkTimeOutError];
  CallBlock(self.completionBlock, nil, error);
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
  self.user = user; // should invoke completion block
}

@end