//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>


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

- (nullable FBLoginView *)addFacebookLoginButtonToFillContainerView:(nonnull UIView *)containerView dismissViewControllerOnCompletion:(nullable UIViewController *)viewControllerToDismiss;

@end
