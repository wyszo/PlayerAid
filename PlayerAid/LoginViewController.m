//
//  PlayerAid
//

#import <UIView+FLKAutolayout.h>
#import "LoginViewController.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginAppearanceHelper.h"
#import "TextFieldsFormHelper.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *loginTextFields;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textFieldContainers;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *facebookLoginContainerView;
@property (strong, nonatomic) LoginAppearanceHelper *appearanceHelper;
@property (strong, nonatomic) TextFieldsFormHelper *textFieldsFormHelper;
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
  [self setupTextFieldsFormHelper];
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
  
  [self.appearanceHelper setNextKeyboardReturnKeysForTextfields:self.loginTextFields delegate:self];
  self.passwordTextField.returnKeyType = UIReturnKeyDone;
}

- (void)setupTextFieldsFormHelper
{
  NSArray *textFields = @[ self.emailTextField, self.passwordTextField ];
  self.textFieldsFormHelper = [[TextFieldsFormHelper alloc] initWithTextFieldsToChain:textFields];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // see https://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons/ for how to build jumping to next textfield better (ignore most upvoted answer)
  
  AssertTrueOrReturnNil(self.textFieldsFormHelper);
  [self.textFieldsFormHelper textFieldShouldReturn:textField];
  
  return YES;
}

@end
