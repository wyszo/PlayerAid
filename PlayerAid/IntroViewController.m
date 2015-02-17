//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import "IntroViewController.h"
#import "FacebookLoginControlsFactory.h"


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
  FBLoginView *loginView = [FacebookLoginControlsFactory facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:^(NSError *error) {
    if (!error) {
      [self dismissViewController];
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
