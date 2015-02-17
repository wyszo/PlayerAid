//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import <KZAsserts.h>
#import "IntroViewController.h"
#import "FacebookLoginControlsFactory.h"
#import "AuthenticationController_SavingToken.h"
#import "ColorsHelper.h"


@implementation IntroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addFacebookLoginButton];
  
  self.view.backgroundColor = [ColorsHelper loginViewBackgroundColor];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

#pragma mark - Facebook login

- (void)addFacebookLoginButton
{
  __weak typeof(self) weakSelf = self;
  FBLoginView *loginView = [FacebookLoginControlsFactory facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:^(NSString *apiToken, NSError *error) {
    if (!error) {
      [AuthenticationController saveApiAuthenticationTokenToUserDefaults:apiToken];
      [weakSelf dismissViewController];
    }
  }];
  
  loginView.center = self.view.center;
  [self.view addSubview:loginView];
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DEBUG IBActions

- (IBAction)debugSkipLoginButtonPressed:(id)sender
{
  [self dismissViewController];
}

@end
