//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import <UIView+FLKAutoLayout.h>
#import <KZAsserts.h>
#import "IntroViewController.h"
#import "FacebookLoginControlsFactory.h"
#import "AuthenticationController_SavingToken.h"
#import "ColorsHelper.h"


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
    if (!error) {
      [AuthenticationController saveApiAuthenticationTokenToUserDefaults:apiToken];
      [weakSelf dismissViewController];
    }
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
}

- (IBAction)termsAndConditionsButtonPressed:(id)sender
{
  [self performSegueWithIdentifier:@"TermsAndConditionsSegue" sender:self];
}

@end
