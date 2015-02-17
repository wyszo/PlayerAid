//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import "IntroViewController.h"
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

#pragma mark - DEBUG IBActions

- (IBAction)debugSkipLoginButtonPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
