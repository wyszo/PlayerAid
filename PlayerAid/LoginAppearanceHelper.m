//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import FLKAutoLayout;
#import "LoginAppearanceHelper.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginManager.h"
#import "NSError+PlayerAidErrors.h"
#import "FacebookAuthenticationController.h"
#import "AlertFactory.h"

@implementation LoginAppearanceHelper

- (void)skinLoginFormTextFieldContainers:(nonnull NSArray *)textFieldContainers
{
  AssertTrueOrReturn(textFieldContainers.count);
  
  [textFieldContainers enumerateObjectsUsingBlock:^(UIView *containerView, NSUInteger idx, BOOL *stop) {
    [containerView tw_addBorderWithWidth:1.0 color:[UIColor lightGrayColor]];
  }];
}

- (void)skinLoginSignupButton:(nonnull UIButton *)button
{
  AssertTrueOrReturn(button);
  
  button.backgroundColor = [UIColor clearColor];
  UIColor *buttonColor = [ColorsHelper playerAidBlueColor];
  [button tw_addBorderWithWidth:1.0 color:buttonColor];
  [button setTitleColor:buttonColor forState:UIControlStateNormal];
}

- (void)setLoginSignupViewBackgroundColor:(nonnull UIView *)view
{
  AssertTrueOrReturn(view);
  view.backgroundColor = [ColorsHelper loginSignupLightBlueBackgroundColor];
}

- (void)setupPasswordTextfield:(nonnull UITextField *)passwordTextfield
{
  AssertTrueOrReturn(passwordTextfield);
  
  passwordTextfield.secureTextEntry = YES;
  passwordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setDefaultTextColorForTextFields:(nonnull NSArray *)textfields
{
  AssertTrueOrReturn(textfields.count);
  
  for (UITextField *textField in textfields) {
    textField.textColor = [UIColor blackColor];
  }
}

#pragma mark - Keyboard keys customisation

- (void)setNextKeyboardReturnKeysForTextfields:(nonnull NSArray *)textfields delegate:(nullable id<UITextFieldDelegate>)delegate
{
  AssertTrueOrReturn(textfields.count);
  
  for (NSObject* object in textfields) {
    AssertTrueOrReturn([object isKindOfClass:[UITextField class]]);
    
    UITextField *textField = (UITextField *)object;
    if (delegate) {
      textField.delegate = delegate;
    }
    textField.returnKeyType = UIReturnKeyNext;
  }
}

#pragma mark - Facebook login button

- (nullable FBSDKLoginButton *)addFacebookLoginButtonToFillContainerView:(nonnull UIView *)containerView parentViewControllerToDismissOnCompletion:(nullable UIViewController *)parentViewController
{
  AssertTrueOrReturnNil(containerView);
  __weak typeof(parentViewController) weakViewController = parentViewController;
  __block TWFullscreenActivityIndicatorView *activityIndicator;
  
  FBSDKLoginButton *loginButton = [FacebookLoginControlsFactory facebookLoginButtonTriggeringInternalAuthenticationWithAction:^(){
    activityIndicator = [TWFullscreenActivityIndicatorView new];
    [parentViewController.navigationController.view addSubview:activityIndicator];
  } completion:^(NSString *apiToken, NSError *error) {
    if (!error) {
      [[LoginManager new] loginWithApiToken:apiToken userLinkedWithFacebook:YES completion:^(NSError *error){
        [weakViewController dismissViewControllerAnimated:YES completion:^() {
          [activityIndicator dismiss];
        }];
      }];
    } else if (error.code == [NSError emailAddressAlreadyUsedForRegistrationError].code) {
      [activityIndicator dismiss];
      [[FacebookAuthenticationController new] logout]; // TODO: inject FAC as an external dependency
      [TWAlertFactory showOKAlertViewWithMessage:@"Hey, it looks like you already signed up with email. Please log in using that method!"];
    }
    else if (error && ![error isURLRequestErrorUserCancelled]) {
      [AlertFactory showGenericErrorAlertViewNoRetry];
      [activityIndicator dismiss];
    } 
    else {
      [activityIndicator dismiss];
    }
  }];
  
  containerView.backgroundColor = [UIColor clearColor];
  
  [containerView addSubview:loginButton];
  [loginButton alignToView:containerView];
  
  return loginButton;
}

@end
