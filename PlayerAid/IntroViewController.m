//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import "IntroViewController.h"
#import "AuthenticationController.h"


@interface IntroViewController ()
@end


// TODO: this view should be presented as modal without animation at the beginning
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
  FBLoginView *loginView = [AuthenticationController  facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:^(NSError *error) {

    if (!error) {
      // TODO: Push the authenticated view hierarchy!!
    }
  }];
  
  loginView.center = self.view.center;
  [self.view addSubview:loginView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}

@end
