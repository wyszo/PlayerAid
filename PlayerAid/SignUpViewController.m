//
//  PlayerAid
//

#import "SignUpViewController.h"

static NSString *const kPrivacyPolicySegueId = @"PrivacyPolicySegueId";
static NSString *const kTermsOfUseSegueId = @"TermsOfUseSegueId";


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *facebookSignUpContainerView;

@end


@implementation SignUpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Sign up";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  // TODO: view skinning
}

#pragma mark - IBActions

- (IBAction)signUpButtonPressed:(id)sender {
  // TODO: data validation (in a new class)
  // TODO: signup nework request
  // TODO: encode password using RSA
  // TODO: handling network responses
}

@end
