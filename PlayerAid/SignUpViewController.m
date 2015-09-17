//
//  PlayerAid
//

#import <UIView+FLKAutolayout.h>
#import "SignUpViewController.h"
#import "SignUpValidator.h"
#import "UnauthenticatedServerCommunicationController.h"
#import "AlertFactory.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginManager.h"


static NSString *const kPrivacyPolicySegueId = @"PrivacyPolicySegueId";
static NSString *const kTermsOfUseSegueId = @"TermsOfUseSegueId";


@interface SignUpViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *signUpTextFields;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *facebookSignUpContainerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textfieldBackgroundViews;
@property (strong, nonatomic) SignUpValidator *validator;
@end


@implementation SignUpViewController

#pragma mark - Setup

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Sign up";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  self.validator = [SignUpValidator new];
  
  [self skinView];
  [self setupTextFields];
  [self setupFacebookButton];
}

#pragma mark - Subviews skinning

- (void)skinView
{
  self.view.backgroundColor = [ColorsHelper loginSignupLightBlueBackgroundColor];
  
  [self skinTextFields];
  [self skinSignUpButton];
}

- (void)skinTextFields
{
  [self.textfieldBackgroundViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    [view tw_addBorderWithWidth:1.0 color:[UIColor lightGrayColor]];
  }];
}

- (void)skinSignUpButton
{
  self.signUpButton.backgroundColor = [UIColor clearColor];
  UIColor *buttonColor = [ColorsHelper playerAidBlueColor];
  [self.signUpButton tw_addBorderWithWidth:1.0 color:buttonColor];
  [self.signUpButton setTitleColor:buttonColor forState:UIControlStateNormal];
}

#pragma mark - TextField setup

- (void)setupTextFields
{
  for (UITextField *textField in self.signUpTextFields) {
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
  }
  self.repeatPasswordTextField.returnKeyType = UIReturnKeyDone;
  
  [self setupPasswordTextfield:self.passwordTextField];
  [self setupPasswordTextfield:self.repeatPasswordTextField];
}

- (void)setupPasswordTextfield:(nonnull UITextField *)passwordTextField
{
  AssertTrueOrReturn(passwordTextField);
  passwordTextField.secureTextEntry = YES;
  passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - Setup Facebook

- (void)setupFacebookButton
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
  
  UIView *loginButtonParentView = self.facebookSignUpContainerView;
  loginButtonParentView.backgroundColor = [UIColor clearColor];
  
  [loginButtonParentView addSubview:loginView];
  [loginView alignToView:loginButtonParentView];
}

#pragma mark - Other methods

- (void)clearPasswordFields
{
  self.passwordTextField.text = @"";
  self.repeatPasswordTextField.text = @"";
}

- (void)setEmailTextFieldsTextColorRed
{
  self.emailTextField.textColor = [UIColor redColor];
}

- (void)setPasswordTextFieldsTextColorRed
{
  self.passwordTextField.textColor = [UIColor redColor];
  self.repeatPasswordTextField.textColor = [UIColor redColor];
}

- (void)setTextFieldsDefaultTextColor
{
  for (UITextField *textField in self.signUpTextFields) {
    textField.textColor = [UIColor blackColor];
  }
}

#pragma mark - Accessors

- (NSString *)emailAddress
{
  return [self.emailTextField.text tw_stringByTrimmingWhitespaceAndNewline];
}

- (NSString *)password
{
  return self.passwordTextField.text;
}

- (NSString *)repeatedPassword
{
  return self.repeatPasswordTextField.text;
}

#pragma mark - DataValidation

- (BOOL)validateEmailAndPassword
{
  BOOL emailValid = [self.validator validateEmail:[self emailAddress]];
  if (!emailValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"That doesn't seem like a valid email address. Can you try again?"];
    [self setEmailTextFieldsTextColorRed];
    return NO;
  }
  
  BOOL passwordValid = [self.validator validatePassword:[self password]];
  if (!passwordValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"We want to keep your account safe, so we ask that your password has at least 6 characters."];
    [self setPasswordTextFieldsTextColorRed];
    return NO;
  }
  
  BOOL passwordsMatch = [[self password] isEqualToString:[self repeatedPassword]];
  if (!passwordsMatch) {
    [TWAlertFactory showOKAlertViewWithMessage:@"Sorry, the passwords you entered don't match. Can you try again?"];
    [self setPasswordTextFieldsTextColorRed];
    return NO;
  }
  return YES;
}

#pragma mark - IBActions

- (IBAction)signUpButtonPressed:(id)sender
{
  if([self validateEmailAndPassword]) {
    [[UnauthenticatedServerCommunicationController sharedInstance] signUpWithEmail:[self emailAddress] password:[self password] completion:^(NSString * __nullable apiToken,  NSError * __nullable error) {
      if (error) {
        [AlertFactory showGenericErrorAlertViewNoRetry];
      } else {
        // TODO: save API token and dismiss login
        NOT_IMPLEMENTED_YET_RETURN
      }
    }];
  }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.emailTextField) {
    [self.passwordTextField becomeFirstResponder];
  } else if (textField == self.passwordTextField) {
    [self.repeatPasswordTextField becomeFirstResponder];
  } else if (textField == self.repeatPasswordTextField) {
    [textField resignFirstResponder];
  }
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  [self setTextFieldsDefaultTextColor];
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  [self setTextFieldsDefaultTextColor];
  return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
  [self setTextFieldsDefaultTextColor];
  return YES;
}

@end
