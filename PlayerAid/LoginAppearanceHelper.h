//
//  PlayerAid
//

@import FBSDKCoreKit;

@interface LoginAppearanceHelper : NSObject

- (void)skinLoginFormTextFieldContainers:(nonnull NSArray *)textFieldContainers;
- (void)skinLoginSignupButton:(nonnull UIButton *)button;
- (void)setLoginSignupViewBackgroundColor:(nonnull UIView *)view;
- (void)setupPasswordTextfield:(nonnull UITextField *)passwordTextfield;

- (void)setDefaultTextColorForTextFields:(nonnull NSArray *)textfields;

/**
 Keyboard buttons in textfields are set to 'Next'. Delegate is set for all of them (if provided).
 */
- (void)setNextKeyboardReturnKeysForTextfields:(nonnull NSArray *)textfields delegate:(nullable id<UITextFieldDelegate>)delegate;

/**
 Additionally presents an activity indicator on parentViewController while trying to LogIn
 */
- (nullable FBLoginView *)addFacebookLoginButtonToFillContainerView:(nonnull UIView *)containerView parentViewControllerToDismissOnCompletion:(nullable UIViewController *)parentViewController;

@end
