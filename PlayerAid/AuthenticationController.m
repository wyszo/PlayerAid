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
  FBLoginView *loginView = [FacebookAuthenticationController  facebookLoginViewWithLoginCompletion:^(id<FBGraphUser> user, NSError *error) {
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
      
      [ServerCommunicationController requestAPITokenWithAuthenticationRequestData:authRequestData completion:^(NSHTTPURLResponse *response, NSError *error) {
        if (error) {
          NSLog(@"Internal authentication failure!");
          
          // TODO: Show generic error!
          // TODO: maybe retry every 15 seconds??
        }
        else {
          NSLog(@"Internal authentication success!");
          
          // TODO: save the access token from the response
          
          if (completion) {
            completion(nil);
          }
        }
      }];
    }
  }];
  return loginView;
}

@end
