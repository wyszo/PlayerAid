//
//  PlayerAid
//

#import <UIView+FLKAutolayout.h>
#import "LoginViewController.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Log In";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  [self skinView];
  [self setupFacebookLoginButton];
}

- (void)skinView
{
  self.view.backgroundColor = [ColorsHelper loginLogInLightBlueBackgroundColor];
}

- (void)setupFacebookLoginButton
{
  defineWeakSelf();
  
  FBLoginView *loginView = [FacebookLoginControlsFactory facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:^(NSString *apiToken, NSError *error) {
    if (!error) {
      [[LoginManager new] loginWithApiToken:apiToken completion:^(NSError *error){
        if (!error) {
          [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
      }];
    }
  }];
  
  UIView *loginButtonParentView = self.view;

  [loginButtonParentView addSubview:loginView];
  [loginView alignCenterWithView:loginButtonParentView];
}

@end
