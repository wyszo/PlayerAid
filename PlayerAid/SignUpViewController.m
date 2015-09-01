//
//  PlayerAid
//

#import "SignUpViewController.h"
#import "SignUpValidator.h"
#import "UnauthenticatedServerCommunicationController.h"
#import "AlertFactory.h"
#import "ColorsHelper.h"


static NSString *const kPrivacyPolicySegueId = @"PrivacyPolicySegueId";
static NSString *const kTermsOfUseSegueId = @"TermsOfUseSegueId";


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *facebookSignUpContainerView;
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
}

- (void)setupPasswordTextfield:(nonnull UITextField *)passwordTextField
{
  AssertTrueOrReturn(passwordTextField);
  passwordTextField.secureTextEntry = YES;
  passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)skinView
{
  self.view.backgroundColor = [ColorsHelper loginSignupLightBlueBackgroundColor];
  
  [self setupPasswordTextfield:self.passwordTextField];
  [self setupPasswordTextfield:self.repeatPasswordTextField];
}

#pragma mark - Other methods

- (void)clearPasswordFields
{
  self.passwordTextField.text = @"";
  self.repeatPasswordTextField.text = @"";
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
    return NO;
  }
  
  BOOL passwordValid = [self.validator validatePassword:[self password]];
  if (!passwordValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"We want to keep your account safe, so we ask that your password has at least 6 characters."];
    return NO;
  }
  
  BOOL passwordsMatch = [[self password] isEqualToString:[self repeatedPassword]];
  if (!passwordsMatch) {
    [TWAlertFactory showOKAlertViewWithMessage:@"Sorry, the passwords you entered don't match. Can you try again?"];
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

@end
