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
  
  // TODO: view skinning
}

#pragma mark - Other methods

- (NSString *)emailAddress {
  return [self.emailTextField.text tw_stringByTrimmingWhitespaceAndNewline];
}

- (NSString *)password {
  return self.passwordTextField.text;
}

#pragma mark - IBActions

- (IBAction)signUpButtonPressed:(id)sender {
  // TODO: data validation (in a new class)
  BOOL emailValid = [self.validator validateEmail:[self emailAddress]];
  if (!emailValid) {
    // TODO: present error
    return;
  }
  
  BOOL passwordValid = [self.validator validatePassword:[self password]];
  if (!passwordValid) {
    // TODO: present error
    return;
  }
  
  // TODO: signup nework request
  // TODO: encode password using RSA
  // TODO: handling network responses
}

@end
