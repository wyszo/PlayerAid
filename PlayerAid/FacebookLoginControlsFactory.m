//
//  PlayerAid
//

#import "FacebookLoginControlsFactory.h"
#import "FacebookAuthenticationController.h"
#import "UnauthenticatedServerCommunicationController.h"
#import "AlertFactory.h"
#import "DataExtractionHelper.h"
#import "DispatchHelper.h"


static const NSTimeInterval kTimeDelayToRetryAuthenticationRequest = 5;

@interface FacebookLoginControlsFactory ()
@property (nonatomic, weak) UIAlertView *serverUnreachableAlertView;
@end


@implementation FacebookLoginControlsFactory

+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Creating Facebook login button

+ (FBLoginView *)facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:(void (^)(NSString *apiToken, NSError *error))completion
{
  FBLoginView *loginView = [FacebookAuthenticationController facebookLoginViewWithLoginCompletion:^(id<FBGraphUser> user, NSError *error) {
    if (error) {
      [AlertFactory showAlertFromFacebookError:error];
    }
    else {
      AuthenticationRequestData *authRequestData = [AuthenticationRequestData new];
      authRequestData.email = [DataExtractionHelper emailFromFBGraphUser:user];
      NSLog(@"email: %@", authRequestData.email);
      
      AssertTrueOrReturn(FBSession.activeSession.isOpen);
      
      authRequestData.facebookAuthenticationToken = FBSession.activeSession.accessTokenData.accessToken;
      NSLog(@"access token: %@", authRequestData.facebookAuthenticationToken);
      
      [[self sharedInstance] sendAuthenticationApiRequestWithAuthenticationRequestData:authRequestData showErrorOnFailure:YES completion:completion];
    }
  }];
  return loginView;
}

- (void)sendAuthenticationApiRequestWithAuthenticationRequestData:(AuthenticationRequestData *)authRequestData
                                               showErrorOnFailure:(BOOL)showErrorOnFailure
                                                       completion:(void (^)(NSString *apiToken, NSError *error))completion
{
  __weak typeof(self) weakSelf = self;
  [UnauthenticatedServerCommunicationController requestAPITokenWithAuthenticationRequestData:authRequestData completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      NSLog(@"Internal authentication failure!");
      
      // possible error codes:
      // 1100 - facebook token invalid
      // 1101 - facebook token expired
      
      [weakSelf showServerUnreachableAlert:showErrorOnFailure andRetryAuthenticationRequestAfterDelayWithData:authRequestData completion:completion];
    }
    else {
      NSString *accessToken = [weakSelf accessTokenFromResponseObject:responseObject];
      if (accessToken.length == 0) {
        NSLog(@"Internal authentication failure!");
        [weakSelf showServerUnreachableAlert:showErrorOnFailure andRetryAuthenticationRequestAfterDelayWithData:authRequestData completion:completion];
        return;
      }
      
      NSLog(@"Internal authentication success!");
      [weakSelf dismissServerUnreachableAlertViewIfPresented];
      
      if (completion) {
        completion(accessToken, nil);
      }
    }
  }];
}

- (NSString *)accessTokenFromResponseObject:(id)responseObject
{
  AssertTrueOrReturnNil([responseObject isKindOfClass:[NSDictionary class]]);
  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
  NSString *accessToken = responseDictionary[@"accessToken"];
  AssertTrueOrReturnNil(accessToken.length > 0);
  return accessToken;
}

- (void)dismissServerUnreachableAlertViewIfPresented
{
  if (self.serverUnreachableAlertView) {
    [self.serverUnreachableAlertView dismissWithClickedButtonIndex:0 animated:YES];
  }
}

- (void)showServerUnreachableAlert:(BOOL)showAlert andRetryAuthenticationRequestAfterDelayWithData:(AuthenticationRequestData *)authRequestData completion:(void (^)(NSString *apiToken, NSError *error))completion
{
  if (showAlert) {
    self.serverUnreachableAlertView = [AlertFactory showGenericErrorAlertView];
  }
  [self retryAuthenticationRequestAfterDelaywWithData:authRequestData showErrorOnFailure:NO completion:completion];
}

- (void)retryAuthenticationRequestAfterDelaywWithData:(AuthenticationRequestData *)authRequestData showErrorOnFailure:(BOOL)showErrorOnFailure completion:(void (^)(NSString *apiToken, NSError *error))completion
{
  __weak typeof(self) weakSelf = self;
  DISPATCH_AFTER(kTimeDelayToRetryAuthenticationRequest, ^{
    [weakSelf sendAuthenticationApiRequestWithAuthenticationRequestData:authRequestData showErrorOnFailure:showErrorOnFailure completion:completion];
  });
}

@end
