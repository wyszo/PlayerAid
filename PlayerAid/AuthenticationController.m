//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "AuthenticationController.h"
#import "FacebookAuthenticationController.h"
#import "ServerCommunicationController.h"
#import "AlertFactory.h"
#import "DataExtractionHelper.h"


static const NSTimeInterval kTimeDelayToRetryAuthenticationRequest = 10;


@interface AuthenticationController ()

@end


@implementation AuthenticationController

+ (AuthenticationController *)sharedInstance
{
  /* Technical debt: could easily avoid making a singleton here */
  static AuthenticationController *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

+ (FBLoginView *)facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:(void (^)(NSError *error))completion
{
  FBLoginView *loginView = [FacebookAuthenticationController facebookLoginViewWithLoginCompletion:^(id<FBGraphUser> user, NSError *error) {
    if (error) {
      [AlertFactory showAlertFromFacebookError:error];
    }
    else {
      AuthenticationRequestData *authRequestData = [AuthenticationRequestData new];
      authRequestData.email = [DataExtractionHelper emailFromUser:user];
      NSLog(@"email: %@", authRequestData.email);
      
      AssertTrueOrReturn(FBSession.activeSession.isOpen);
      
      authRequestData.facebookAuthenticationToken = FBSession.activeSession.accessTokenData.accessToken;
      NSLog(@"access token: %@", authRequestData.facebookAuthenticationToken);
      
      [[AuthenticationController sharedInstance] sendAuthenticationApiRequestWithAuthenticationRequestData:authRequestData showErrorOnFailure:YES completion:completion];
    }
  }];
  return loginView;
}

- (void)sendAuthenticationApiRequestWithAuthenticationRequestData:(AuthenticationRequestData *)authRequestData
                                               showErrorOnFailure:(BOOL)showErrorOnFailure
                                                       completion:(void (^)(NSError *error))completion
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
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeDelayToRetryAuthenticationRequest * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf sendAuthenticationApiRequestWithAuthenticationRequestData:authRequestData showErrorOnFailure:NO completion:completion];
      });
    }
    else {
      NSLog(@"Internal authentication success!");
      
      // TODO: save the access token from the response
      // TODO: (Nice to have) - implement our internal access token caching
      // TODO: (Nice to have) - reuse old token if using same Facebook authentication
      
      if (completion) {
        completion(nil);
      }
    }
  }];
}

@end
