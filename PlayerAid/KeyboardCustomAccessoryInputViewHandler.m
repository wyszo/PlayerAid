//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "KeyboardCustomAccessoryInputViewHandler.h"
#import "UsersFetchController.h"
#import "User.h"
#import "MakeCommentInputViewController.h"

static const CGFloat kInputViewSlideInOutAnimationDuration = 0.5f;

@interface KeyboardCustomAccessoryInputViewHandler()
@property (nonatomic, strong) UIViewController *accessoryKeyboardInputViewController;
@property (nonatomic, assign) CGFloat desiredInputViewHeight;
@property (nonatomic, assign) BOOL inputViewVisible;
@end

@implementation KeyboardCustomAccessoryInputViewHandler

#pragma mark - Init

- (instancetype)initWithAccessoryKeyboardInputViewController:(UIViewController *)viewController desiredInputViewHeight:(CGFloat)inputViewHeight
{
  AssertTrueOrReturnNil(viewController);
  AssertTrueOrReturnNil(inputViewHeight > 0);
  
  self = [super init];
  if (self) {
    _accessoryKeyboardInputViewController = viewController;
    _desiredInputViewHeight = inputViewHeight;
    [self setupKeyboardInputView];
    [self setupAccessoryKeyboardInputViewNotificationCallbacks];
  }
  return self;
}

- (void)dealloc
{
  [self invokeSlideInputViewOutAnimationWithCompletion:nil];
}

- (void)setupKeyboardInputView
{
  UIView *accessoryInputView = self.accessoryKeyboardInputViewController.view;
  AssertTrueOrReturn(accessoryInputView);
  
  accessoryInputView.autoresizingMask = UIViewAutoresizingNone; // required for being able to change inputView height
  accessoryInputView.tw_height = self.desiredInputViewHeight;
}

#pragma mark - Notifications setup

- (void)setupAccessoryKeyboardInputViewNotificationCallbacks
{
  [self setupKeyboardDidShowNotificationHandler];
  [self setupKeyboardWillHideNotificationHandler];
}

- (void)setupKeyboardDidShowNotificationHandler
{
  const CGFloat kInputViewToKeyboardTopAnimationDuration = 0.2f;
  
  defineWeakSelf();
  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    defineStrongSelf();
    CGRect keyboardFrameRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]; // note we don't use convertRect: in here, no need
    
    strongSelf.accessoryKeyboardInputViewController.view.tw_top = keyboardFrameRect.origin.y; // position instantly just below top of the keyboard
    [UIView animateWithDuration:kInputViewToKeyboardTopAnimationDuration animations:^{
      strongSelf.accessoryKeyboardInputViewController.view.tw_bottom = keyboardFrameRect.origin.y; // animate slide in
    }];
  }];
}

- (void)setupKeyboardWillHideNotificationHandler
{
  defineWeakSelf();
  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    weakSelf.accessoryKeyboardInputViewController.view.tw_bottom = [UIScreen tw_height]; // in here this will be animated automatically (with keyboard animation)
  }];
}

#pragma mark - public interface

- (void)slideInputViewIn
{
  AssertTrueOrReturn(self.inputVC.view.superview == nil);
  [self installInputViewInKeyWindow];
  self.inputViewVisible = YES;
  
  [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
    self.inputVC.view.tw_bottom = [UIScreen tw_height];
  }];
}

- (void)slideInputViewOut
{
  __strong UIView *strongInputView = self.accessoryKeyboardInputViewController.view; // we want to prolong this object lifetime to ensure completion block gets executed!
  AssertTrueOr(self.desiredInputViewHeight > 0,);
  
  defineWeakSelf();
  [self invokeSlideInputViewOutAnimationWithCompletion:^(BOOL finished) {
    weakSelf.inputViewVisible = NO;
    [strongInputView removeFromSuperview];
    CallBlock(weakSelf.inputViewDidDismissBlock);
  }];
}

- (void)invokeSlideInputViewOutAnimationWithCompletion:(BlockWithBoolParameter)completion
{
  [self.inputVC willMoveToParentViewController:nil];
  [self.inputVC removeFromParentViewController];
  [self.inputVC didMoveToParentViewController:nil];
  
  [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
    self.accessoryKeyboardInputViewController.view.tw_bottom = [UIScreen tw_height] + self.desiredInputViewHeight;
  } completion:completion];
}

- (void)installInputViewInKeyWindow
{
  UIViewController *parentVC = [UIWindow tw_keyWindow].rootViewController;
  AssertTrueOrReturn(parentVC);
  AssertTrueOrReturn(self.inputVC.view.superview == nil);
  
  [parentVC willMoveToParentViewController:parentVC];
  [parentVC.view addSubview:self.inputVC.view];
  [parentVC didMoveToParentViewController:parentVC];
  
  [self positionInputViewBelowTheScreen];
}

#pragma mark - private

- (void)positionInputViewBelowTheScreen
{
  self.inputVC.view.tw_width = [UIScreen tw_width];
  self.inputVC.view.tw_bottom = [UIScreen tw_height] + self.inputVC.view.tw_height;
}

- (UIViewController *)inputVC
{
  return self.accessoryKeyboardInputViewController;
}

@end
