//
//  PlayerAid
//

#import <UIView+FLKAutolayout.h>
#import "LoginViewController.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginAppearanceHelper.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textFieldContainers;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *facebookLoginContainerView;
@property (strong, nonatomic) LoginAppearanceHelper *appearanceHelper;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Log In";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  self.appearanceHelper = [LoginAppearanceHelper new];
  [self.appearanceHelper addFacebookLoginButtonToFillContainerView:self.facebookLoginContainerView dismissViewControllerOnCompletion:self];
  
  [self skinView];
  [self setupTextFields];
}

- (void)skinView
{
  AssertTrueOrReturn(self.appearanceHelper);
  [self.appearanceHelper setLoginSignupViewBackgroundColor:self.view];
  [self.appearanceHelper skinLoginFormTextFieldContainers:self.textFieldContainers];
  [self.appearanceHelper skinLoginSignupButton:self.loginButton];
}

- (void)setupTextFields
{
  AssertTrueOrReturn(self.appearanceHelper);
  [self.appearanceHelper setupPasswordTextfield:self.passwordTextField];
}

@end
