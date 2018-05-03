//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import TTTAttributedLabel;
#import "SignUpViewController.h"
#import "SignUpValidator.h"
#import "UnauthenticatedServerCommunicationController.h"
#import "AlertFactory.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginAppearanceHelper.h"
#import "LoginSignUpComponentsConfigurator.h"
#import "ColorsHelper.h"
#import "LoginManager.h"
#import "DebugSettings.h"
#import "GlobalSettings.h"

static NSString *const kPrivacyPolicySegueId = @"PrivacyPolicySegueId";
static NSString *const kTermsOfUseSegueId = @"TermsOfUseSegueId";

static NSString *const kInvalidEmailAddressMessage = @"That doesn't seem like a valid email address. Can you try again?";


@interface SignUpViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textFieldContainers;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textfieldBackgroundViews;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *signUpTextFields;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *facebookSignUpContainerView;
@property (strong, nonatomic) SignUpValidator *validator;
@property (strong, nonatomic) LoginAppearanceHelper *appearanceHelper;
@property (strong, nonatomic) TWTextFieldsFormHelper *textFieldsFormHelper;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *bottomAttributedLabel;
@end


@implementation SignUpViewController

#pragma mark - Setup

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Sign up";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  self.validator = [SignUpValidator new];
  self.appearanceHelper = [LoginAppearanceHelper new];
  
  [self skinView];
  [self setupTextFields];
  [self setupTextFieldsFormHelper];
  [self setupBottomTextView];
  
  [self.appearanceHelper addFacebookLoginButtonToFillContainerView:self.facebookSignUpContainerView parentViewControllerToDismissOnCompletion:self];
  
  [self sendDebugSignUpRequestIfNeeded];
}

- (void)sendDebugSignUpRequestIfNeeded
{
  if (DEBUG_SEND_VALID_SIGNUP_REQUEST || DEBUG_SEND_INVALID_SIGNUP_REQUEST) {
    // TODO: move the implementation to a separate debug class
    
    defineWeakSelf();
    DISPATCH_AFTER(1.0, ^{
      NSInteger testAccountNumber = 8855;
      
      if (DEBUG_SEND_VALID_SIGNUP_REQUEST) {
        testAccountNumber = 1000 + arc4random_uniform(9000);
      }
      NSString *emailAddress = [NSString stringWithFormat:@"test%ld@test.test", testAccountNumber];
    
      [[UnauthenticatedServerCommunicationController sharedInstance] signUpWithEmail:emailAddress password:@"blablabla" completion:^(NSString * _Nullable apiToken, id responseObject, NSError * _Nullable error) {
        if (error) {
          [weakSelf displaySignUpServerError:((NSDictionary *)responseObject)];
        } else {
          [weakSelf loginUsingApiToken:apiToken completion:nil];
        }
        NSLog(@"DEBUG SIGNUP REQUEST SEND");
      }];
    });
  }
}

- (void)setupTextFieldsFormHelper
{
  NSArray *textFields = @[ self.emailTextField, self.passwordTextField, self.repeatPasswordTextField ];
  self.textFieldsFormHelper = [[TWTextFieldsFormHelper alloc] initWithTextFieldsToChain:textFields];
}

- (void)setupBottomTextView
{
  self.bottomAttributedLabel.delegate = self;
  [[LoginSignUpComponentsConfigurator new] configureSignupBottomTermsAndConditionsPrivacyPolicyAttributedLabel:self.bottomAttributedLabel];
}

#pragma mark - Subviews skinning

- (void)skinView
{
  AssertTrueOrReturn(self.appearanceHelper);
  
  [self.appearanceHelper setLoginSignupViewBackgroundColor:self.view];
  [self.appearanceHelper skinLoginFormTextFieldContainers:self.textFieldContainers];
  [self.appearanceHelper skinLoginSignupButton:self.signUpButton];
}

#pragma mark - TextField setup

- (void)setupTextFields
{
  AssertTrueOrReturn(self.appearanceHelper);
  [self.appearanceHelper setupPasswordTextfield:self.passwordTextField];
  [self.appearanceHelper setupPasswordTextfield:self.repeatPasswordTextField];
  
  [self.appearanceHelper setNextKeyboardReturnKeysForTextfields:self.signUpTextFields delegate:self];
  self.repeatPasswordTextField.returnKeyType = UIReturnKeyDone;
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
  [self.appearanceHelper setDefaultTextColorForTextFields:self.signUpTextFields];
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

#pragma mark - Data Validation

- (BOOL)validateEmailAndPassword
{
  AssertTrueOrReturnNo(self.validator);
  
  BOOL emailValid = [self.validator validateEmail:[self emailAddress]];
  if (!emailValid) {
    [TWAlertFactory showOKAlertViewWithMessage:kInvalidEmailAddressMessage];
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

#pragma mark - Auxiliary methods

- (NSString *)signupErrorForErrorCode:(NSInteger)errorCode
{
  NSDictionary *signUpErrorCodesMapping = @{
                                      @(5200) : kInvalidEmailAddressMessage,
                                      @(5201) : @"Hey, it looks like you already registered so please log in!",
                                      @(5202) : @"Hey, it looks like you already signed up with Facebook. Please log in using that method!", // lexem needs approval
                                      @(5300) : @"We want to keep your account safe, so we ask that your password has at least 6 characters.",
                                      @(5301) : @"Password to weak!" // lexem needs approval
                                      };
  NSString *errorMessage = signUpErrorCodesMapping[@(errorCode)];
  return errorMessage;
}

- (void)displaySignUpServerError:(nonnull NSDictionary *)serverResponseDictionary
{
  AssertTrueOrReturn(serverResponseDictionary.count);
  NSNumber *errorCode = serverResponseDictionary[@"error"];
  
  NSString *errorMessage = [self signupErrorForErrorCode:[errorCode integerValue]];
  if (!errorMessage.length) {
    // fallback to message from server
    errorMessage = serverResponseDictionary[@"errorMessage"];
  }
  
  if (errorMessage.length) {
    [TWAlertFactory showOKAlertViewWithMessage:errorMessage];
  } else {
    // fallback to generic error message
    [AlertFactory showGenericErrorAlertView];
  }
}

#pragma mark - IBActions

- (IBAction)signUpButtonPressed:(id)sender
{
  [self tw_resignFirstResponder];
  
  if([self validateEmailAndPassword]) {
    TWFullscreenActivityIndicatorView *activityIndicator = [TWFullscreenActivityIndicatorView new];
    [self.navigationController.view addSubview:activityIndicator];
    
    if (OFFLINE_DEMO_ENVIRONMENT) {
      [self dismissViewControllerAnimated:YES completion:^() {
        [activityIndicator dismiss];
      }];
      return;
    }
    
    defineWeakSelf();
    [[UnauthenticatedServerCommunicationController sharedInstance] signUpWithEmail:[self emailAddress] password:[self password] completion:^(NSString * __nullable apiToken, id responseObject, NSError * __nullable error) {
      if (error) {
        [activityIndicator dismiss];
        AssertTrueOr([responseObject isKindOfClass:[NSDictionary class]],);
        [self displaySignUpServerError:((NSDictionary *)responseObject)];
      } else {
        [weakSelf loginUsingApiToken:apiToken completion:^(){
          [activityIndicator dismiss];
        }];
      }
    }];
  }
}

- (void)loginUsingApiToken:(nonnull NSString *)apiToken completion:(nullable VoidBlock)completion
{
  AssertTrueOrReturn(apiToken.length);
  
  defineWeakSelf();
  [[LoginManager new] loginWithApiToken:apiToken userLinkedWithFacebook:NO completion:^(NSError *error){
    if (!error) {
      [weakSelf dismissViewControllerAnimated:YES completion:^() {
        CallBlock(completion, nil);
      }];
    } else {
      [AlertFactory showGenericErrorAlertViewNoRetry];
      CallBlock(completion, nil);
    }
  }];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
  NSString *urlString = url.absoluteString;
  LoginSignUpComponentsConfigurator *configurator = [LoginSignUpComponentsConfigurator new];
  
  if ([urlString isEqualToString:configurator.termsAndConditionsStubUrlString]) {
    [self performSegueWithIdentifier:kTermsOfUseSegueId sender:self];
  } else if ([urlString isEqualToString:configurator.privacyPolicyStubUrlString]) {
    [self performSegueWithIdentifier:kPrivacyPolicySegueId sender:self];
  } else {
    AssertTrueOrReturn(NO && @"Unexpected URL!");
  }
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
