//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import <FacebookSDK/FBSession.h>
#import "KZAsserts.h"
#import "IntroViewController.h"
#import "AlertFactory.h"
#import "AuthenticationController.h"
#import "ServerCommunicationController.h"


@interface IntroViewController ()
@end

@implementation IntroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addFacebookLoginButton];
}

#pragma mark - Facebook login

- (void)addFacebookLoginButton
{
  __weak typeof(self) weakSelf = self;
  
  // TODO: although login button certainly needs to be in here, this whole logic doesn't necessarily belong in here - should be View Controler agnostic!
  FBLoginView *loginView = [AuthenticationController facebookLoginViewWithLoginCompletion:^(id<FBGraphUser> user, NSError *error) {
    if (error) {
      [AlertFactory showAlertFromFacebookError:error];
    }
    else {
      AuthenticationRequestData *authRequestData = [AuthenticationRequestData new];
      authRequestData.email = [weakSelf emailFromUser:user];
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
          // TODO: Push the authenticated view hierarchy!!
        }
      }];
    }
  }];
  
  loginView.center = self.view.center;
  [self.view addSubview:loginView];
}

- (NSString *)emailFromUser:(id<FBGraphUser>)user
{
  // it is possible to have a user without registered email address, but we always want to have one
  NSString *email = [user objectForKey:@"email"];
  return (email ? email : [NSString stringWithFormat:@"%@@facebook.com", user.username]);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}

@end
