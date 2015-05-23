//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import <UIView+FLKAutoLayout.h>
#import "IntroViewController.h"
#import "FacebookLoginControlsFactory.h"
#import "AuthenticationController_SavingToken.h"
#import "ColorsHelper.h"
#import "AuthenticatedServerCommunicationController.h"
#import "ServerDataFetchController.h"


@interface IntroViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginButtonContainer;
@end


@implementation IntroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [ColorsHelper loginViewBackgroundColor];
  [self addFacebookLoginButton];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    if (!error && apiToken.length) {
      [AuthenticationController saveApiAuthenticationTokenToUserDefaults:apiToken];
      [AuthenticatedServerCommunicationController setApiToken:apiToken];
      [weakSelf dismissViewController];
      [ServerDataFetchController updateUserAndTutorials];
    }
    // standard facebook errors and behaviour when apiToken is empty is already handled internally
  }];
  
  AssertTrueOrReturn(self.loginButtonContainer);
  [self.loginButtonContainer addSubview:loginView];
  
  [loginView alignCenterWithView:self.loginButtonContainer];
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DEBUG IBActions

- (IBAction)debugSkipLoginButtonPressed:(id)sender
{
  [self dismissViewController];
  [ServerDataFetchController updateUserAndTutorials];
}

- (IBAction)termsAndConditionsButtonPressed:(id)sender
{
  [self performSegueWithIdentifier:@"TermsAndConditionsSegue" sender:self];
}

@end
