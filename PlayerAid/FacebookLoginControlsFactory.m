//
//  PlayerAid
//

#import "FacebookLoginControlsFactory.h"
#import "FacebookAuthenticationController.h"
#import "ServerCommunicationController.h"
#import "AlertFactory.h"
#import "DataExtractionHelper.h"
#import "DispatchHelper.h"


static const NSTimeInterval kTimeDelayToRetryAuthenticationRequest = 10;


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
  [ServerCommunicationController.sharedInstance requestAPITokenWithAuthenticationRequestData:authRequestData completion:^(NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Internal authentication failure!");
      
      // possible error codes:
      // 1100 - facebook token invalid
      // 1101 - facebook token expired
      
      if (showErrorOnFailure) {
        [AlertFactory showGenericErrorAlertView];
      }
      
      // retry silently on failure after some time delay
      DISPATCH_AFTER(kTimeDelayToRetryAuthenticationRequest, ^{
        [weakSelf sendAuthenticationApiRequestWithAuthenticationRequestData:authRequestData showErrorOnFailure:NO completion:completion];
      });
    }
    else {
      NSLog(@"Internal authentication success!");
      
      // TODO: (Nice to have) - implement our internal access token caching
      // TODO: (Nice to have) - reuse old token if using same Facebook authentication

      NSString *accessToken = response.allHeaderFields[@"accessToken"];
      AssertTrueOrReturn(accessToken.length);
      if (completion) {
        completion(accessToken, nil);
      }
    }
  }];
}

@end
