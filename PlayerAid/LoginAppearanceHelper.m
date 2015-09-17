//
//  PlayerAid
//

#import <UIView+FLKAutolayout.h>
#import "LoginAppearanceHelper.h"
#import "ColorsHelper.h"
#import "FacebookLoginControlsFactory.h"
#import "LoginManager.h"

@implementation LoginAppearanceHelper

- (void)skinLoginFormTextFields:(nonnull NSArray *)textFields
{
  AssertTrueOrReturn(textFields.count);
  
  [textFields enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
    [textField tw_addBorderWithWidth:1.0 color:[UIColor lightGrayColor]];
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

#pragma mark - Facebook login button

- (nullable FBLoginView *)addFacebookLoginButtonToFillContainerView:(nonnull UIView *)containerView dismissViewControllerOnCompletion:(nullable UIViewController *)viewControllerToDismiss
{
  AssertTrueOrReturnNil(containerView);
  __weak typeof(viewControllerToDismiss) weakViewController = viewControllerToDismiss;
  
  FBLoginView *loginView = [FacebookLoginControlsFactory facebookLoginButtonTriggeringInternalAuthenticationWithCompletion:^(NSString *apiToken, NSError *error) {
    if (!error) {
      [[LoginManager new] loginWithApiToken:apiToken completion:^(NSError *error){
        [weakViewController dismissViewControllerAnimated:YES completion:nil];
      }];
    }
  }];
  
  containerView.backgroundColor = [UIColor clearColor];
  
  [containerView addSubview:loginView];
  [loginView alignToView:containerView];
  
  return loginView;
}

@end
