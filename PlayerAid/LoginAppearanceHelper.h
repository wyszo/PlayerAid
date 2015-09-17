//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>


@interface LoginAppearanceHelper : NSObject

- (void)skinLoginFormTextFieldContainers:(nonnull NSArray *)textFieldContainers;
- (void)skinLoginSignupButton:(nonnull UIButton *)button;
- (void)setLoginSignupViewBackgroundColor:(nonnull UIView *)view;

- (nullable FBLoginView *)addFacebookLoginButtonToFillContainerView:(nonnull UIView *)containerView dismissViewControllerOnCompletion:(nullable UIViewController *)viewControllerToDismiss;

@end
