//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import FBSDKCoreKit;
#import "FacebookLoginControlsFactory.h"
#import "FacebookAuthenticationController.h"
#import "UnauthenticatedServerCommunicationController.h"
#import "AlertFactory.h"
#import "DataExtractionHelper.h"
#import "NSError+PlayerAidErrors.h"


static const NSTimeInterval kTimeDelayToRetryAuthenticationRequest = 5;

@interface FacebookLoginControlsFactory ()
@property (nonatomic, weak) UIAlertView *serverUnreachableAlertView;
@end


@implementation FacebookLoginControlsFactory

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - Creating Facebook login button

+ (nullable FBSDKLoginButton *)facebookLoginButtonTriggeringInternalAuthenticationWithAction:(nullable VoidBlock)buttonAction completion:(void (^)(NSString *apiToken, NSError *error))completion
{
  AssertTrueOrReturnNil(completion);
  
  FBSDKLoginButton *loginButton = [FacebookAuthenticationController facebookLoginViewWithAction:buttonAction completion:^(FBSDKProfile *user, NSError *error) {
    if (error) {
      [AlertFactory showAlertFromFacebookError:error];
    }
    else {
      AuthenticationRequestData *authRequestData = [AuthenticationRequestData new];
      authRequestData.email = [DataExtractionHelper emailFromFBGraphUser:user];
      NSLog(@"email: %@", authRequestData.email);
      
      NSString *accessTokenString = [FBSDKAccessToken currentAccessToken].tokenString;
      authRequestData.facebookAuthenticationToken = accessTokenString;
      NSLog(@"access token: %@", authRequestData.facebookAuthenticationToken);
      AssertTrueOrReturn(accessTokenString.length && @"no access token means FB session is not open");
      
      [[self sharedInstance] sendAuthenticationApiRequestWithAuthenticationRequestData:authRequestData showErrorOnFailure:YES completion:completion];
    }
  }];
  return loginButton;
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
      // 1201  - email address already registered
      
      if ([self emailAddressAlreadyUsedForRegistrationWithRequestApiTokenServerResponse:responseObject]) {
        NSError *error = [NSError emailAddressAlreadyUsedForRegistrationError];
        CallBlock(completion, nil, error);
        return;
      } else {
        [weakSelf showServerUnreachableAlert:showErrorOnFailure andRetryAuthenticationRequestAfterDelayWithData:authRequestData   completion:completion];
      }
    }
    else if (!error) {
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

- (BOOL)emailAddressAlreadyUsedForRegistrationWithRequestApiTokenServerResponse:(id)responseObject
{
  if (!responseObject) {
    return NO;
  }
  
  AssertTrueOrReturnNo([responseObject isKindOfClass:[NSDictionary class]]);
  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
  NSNumber *errorCode = responseDictionary[@"error"];
  
  NSInteger kErrorCodeEmailAlreadyUsedForRegistration = 1201; 
  if ([errorCode integerValue] == kErrorCodeEmailAlreadyUsedForRegistration) {
    return YES;
  }
  return NO;
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
