//
//  PlayerAid
//

#import <FLKAutolayout/UIView+FLKAutolayout.h>
#import <TWCommonLib/TWTextFieldsFormHelper.h>
#import <TWCommonLib/TWFullscreenActivityIndicatorView.h>
#import <TWCommonLib/UIViewController+TWResponderChain.h>
#import "LoginViewController.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginAppearanceHelper.h"
#import "UnauthenticatedServerCommunicationController.h"
#import "SignUpValidator.h"
#import "AlertFactory.h"
#import "LoginManager.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *loginTextFields;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textFieldContainers;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *facebookLoginContainerView;
@property (strong, nonatomic) SignUpValidator *validator;
@property (strong, nonatomic) LoginAppearanceHelper *appearanceHelper;
@property (strong, nonatomic) TWTextFieldsFormHelper *textFieldsFormHelper;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Log In";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  self.validator = [SignUpValidator new];
  self.appearanceHelper = [LoginAppearanceHelper new];
  [self.appearanceHelper addFacebookLoginButtonToFillContainerView:self.facebookLoginContainerView parentViewControllerToDismissOnCompletion:self];
  
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
  self.textFieldsFormHelper = [[TWTextFieldsFormHelper alloc] initWithTextFieldsToChain:textFields];
}

#pragma mark - UI helper methods

- (void)setEmailTextFieldsTextColorRed
{
  self.emailTextField.textColor = [UIColor redColor];
}

- (void)setPasswordTextFieldTextColorRed
{
  self.passwordTextField.textColor = [UIColor redColor];
}

- (void)setTextFieldsDefaultTextColor
{
  [self.appearanceHelper setDefaultTextColorForTextFields:self.loginTextFields];
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

#pragma mark - Data Validatoin

- (BOOL)validateEmailAndPassword
{
  AssertTrueOrReturnNo(self.validator);
  
  BOOL emailValid = [self.validator validateEmail:[self emailAddress]];
  if (!emailValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"That doesn't seem like a valid email address. Can you try again?"];
    [self setEmailTextFieldsTextColorRed];
    return NO;
  }

  BOOL passwordValid = [self.validator validatePassword:[self password]];
  if (!passwordValid) {
    [TWAlertFactory showOKAlertViewWithMessage:@"That's not the right password, sorry"];
    [self setPasswordTextFieldTextColorRed];
    return NO;
  }
  return YES;
}

#pragma mark - Error handling

- (void)displayLoginAlertForServerResponse:(id)responseObject
{
  AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
  AssertTrueOrReturn(responseDictionary.count);
  
  NSNumber *errorCode = responseDictionary[@"error"];
  [self displayLoginAlertForErrorCode:errorCode.integerValue];
}

- (void)displayLoginAlertForErrorCode:(NSInteger)errorCode
{
  NSInteger kObsoleteGenericLoginErrorCode = 1200;
  
  NSDictionary *loginErrorCodesMapping = @{
                                           @(kObsoleteGenericLoginErrorCode) : @"Invalid Login Credentials", // lexem needs approval
                                           @(1201) : @"Email address unrecognized", // lexem needs approval
                                           @(1202) : @"That’s not the right password, sorry",
                                           @(1203) : @"Hey, it looks like you already signed up with Facebook. Please log in using that method!'", // lexem needs approval
                                           @(1204) : @"That doesn't seem like a valid email address. Can you try again?",
                                          };
  NSString *errorMessage = loginErrorCodesMapping[@(errorCode)];
  if (!errorMessage.length) {
    [AlertFactory showGenericErrorAlertViewNoRetry];
  } else {
    [TWAlertFactory showOKAlertViewWithMessage:errorMessage];
  }
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender
{
  [self tw_resignFirstResponder];
  
  if([self validateEmailAndPassword]) {
    TWFullscreenActivityIndicatorView *activityIndicator = [TWFullscreenActivityIndicatorView new];
    [self.navigationController.view addSubview:activityIndicator];
    
    defineWeakSelf();
    [[UnauthenticatedServerCommunicationController sharedInstance] loginWithEmail:[self emailAddress] password:[self password] completion:^(NSString * __nullable apiToken, id responseObject, NSError * __nullable error) {
      if (error) {
        [activityIndicator dismiss];
        [self displayLoginAlertForServerResponse:responseObject];
      } else {
        [weakSelf loginWithApiToken:apiToken completion:^{
          [activityIndicator dismiss];
        }];
      }
    }];
  }
}

- (void)loginWithApiToken:(nonnull NSString *)apiToken completion:(nullable VoidBlock)completion
{
  defineWeakSelf();
  [[LoginManager new] loginWithApiToken:apiToken userLinkedWithFacebook:NO completion:^(NSError *error) {
    if (error) {
      [AlertFactory showGenericErrorAlertViewNoRetry];
      CallBlock(completion, nil);
    } else {
      [weakSelf dismissViewControllerAnimated:YES completion:^() {
        CallBlock(completion, nil);
      }];
    }
  }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // see https://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons/ for how to build jumping to next textfield better (ignore most upvoted answer)
  
  AssertTrueOrReturnNil(self.textFieldsFormHelper);
  [self.textFieldsFormHelper textFieldShouldReturn:textField];
  
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
