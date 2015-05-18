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


@interface IntroViewController ()
@end

@implementation IntroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addFacebookLoginButton];
}

#pragma mark - Facebook login

- (void)addFacebookLoginButton{
  
  __weak typeof(self) weakSelf = self;
  FBLoginView *loginView = [AuthenticationController facebookLoginViewWithLoginCompletion:^(id<FBGraphUser> user, NSError *error) {
    if (error) {
      [AlertFactory showAlertFromFacebookError:error];
    }
    else {
      NSString *email = [weakSelf emailFromUser:user];
      NSLog(@"email: %@", email);
      
      AssertTrueOrReturn(FBSession.activeSession.isOpen);
      
      NSString *accessToken = FBSession.activeSession.accessTokenData.accessToken;
      NSLog(@"access token: %@", accessToken);
      
      // TODO: Now we can send the Facebook access token to our API (with user email address) and push the new view
    }
  }];
  
  loginView.center = self.view.center;
  [self.view addSubview:loginView];
}

- (NSString *)emailFromUser:(id<FBGraphUser>)user {
  // it is possible to have a user without registered email address, but we always want to have one
  NSString *email = [user objectForKey:@"email"];
  return (email ? email : [NSString stringWithFormat:@"%@@facebook.com", user.username]);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
