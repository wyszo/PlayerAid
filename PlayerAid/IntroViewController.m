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
#import "ServerDataUpdateController.h"


@interface IntroViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginButtonContainer;
@end


@implementation IntroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [ColorsHelper playerAidBlueColor];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  
  // This is not needed anymore on this view, will be moved to a login modal view
  // [self recreateFacebookLoginButton];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

#pragma mark - Facebook login

// not needed in this view controller
- (void)recreateFacebookLoginButton
{
  __weak typeof(self) weakSelf = self;
  FBLoginView *loginView = [FacebookLoginControlsFactory facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:^(NSString *apiToken, NSError *error) {
    if (!error && apiToken.length) {
      [AuthenticationController saveApiAuthenticationTokenToUserDefaults:apiToken];
      [AuthenticatedServerCommunicationController setApiToken:apiToken];
      [weakSelf dismissViewController];
      [ServerDataUpdateController updateUserAndTutorials];
    }
    // standard facebook errors and behaviour when apiToken is empty is already handled internally
  }];
  
  [self assertZeroOrOneLoginButtonSubviews];
  [self removeLoginButtonContainerSubviews];
  [self.loginButtonContainer addSubview:loginView];
  
  [loginView alignCenterWithView:self.loginButtonContainer];
}

#pragma mark - Helper methods

- (void)assertZeroOrOneLoginButtonSubviews
{
  AssertTrueOrReturn(self.loginButtonContainer);
  
  NSInteger loginButtonContainerSubviews = self.loginButtonContainer.subviews.count;
  AssertTrueOrReturn(loginButtonContainerSubviews == 0 || loginButtonContainerSubviews == 1);
}

- (void)removeLoginButtonContainerSubviews
{
  [self.loginButtonContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
