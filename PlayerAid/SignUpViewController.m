//
//  PlayerAid
//

#import "SignUpViewController.h"
#import "SignUpValidator.h"

static NSString *const kPrivacyPolicySegueId = @"PrivacyPolicySegueId";
static NSString *const kTermsOfUseSegueId = @"TermsOfUseSegueId";


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *facebookSignUpContainerView;
@property (strong, nonatomic) SignUpValidator *validator;

@end


@implementation SignUpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Sign up";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  self.validator = [SignUpValidator new];
  self.passwordTextField.secureTextEntry = YES;
  
  // TODO: view skinning
}

#pragma mark - Other methods

- (void)clearPasswordField
{
  self.passwordTextField.text = @"";
}

#pragma mark - Accessors

- (NSString *)emailAddress {
  return [self.emailTextField.text tw_stringByTrimmingWhitespaceAndNewline];
}

- (NSString *)password {
  return self.passwordTextField.text;
}

#pragma mark - IBActions

- (IBAction)signUpButtonPressed:(id)sender {
  defineWeakSelf();
  
  BOOL emailValid = [self.validator validateEmail:[self emailAddress]];
  if (!emailValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"That doesn't seem like a valid email address. Can you try again?"];
    return;
  }
  
  BOOL passwordValid = [self.validator validatePassword:[self password]];
  if (!passwordValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"We want to keep your account safe, so we ask that your password has at least 6 characters." action:^{
      [weakSelf clearPasswordField];
    }];
    return;
  }
  
  // TODO: signup nework request
  // TODO: encode password using RSA
  // TODO: handling network responses
}

@end
