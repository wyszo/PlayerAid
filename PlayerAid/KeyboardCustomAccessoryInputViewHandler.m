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
@property (nonatomic, assign) CGFloat initialInputViewHeight;
@property (nonatomic, assign) BOOL inputViewSlidOut;
@property (nonatomic, strong) TWKeyboardNotificationsManager *keyboardNotificationsManager;
@end

@implementation KeyboardCustomAccessoryInputViewHandler

#pragma mark - Init

- (instancetype)initWithAccessoryKeyboardInputViewController:(UIViewController *)viewController
                                      initialInputViewHeight:(CGFloat)inputViewHeight
{
  AssertTrueOrReturnNil(viewController);
  AssertTrueOrReturnNil(inputViewHeight > 0);
  
  self = [super init];
  if (self) {
    _accessoryKeyboardInputViewController = viewController;
    _initialInputViewHeight = inputViewHeight;
    _keyboardNotificationsManager = [TWKeyboardNotificationsManager new];
    [self setupKeyboardInputView];
    [self setupAccessoryKeyboardInputViewNotificationCallbacks];
  }
  return self;
}

- (void)dealloc
{
  // watch out for memory leaks, can't rely on this logic in case they happen
  [self slideInputViewOutAnimated:YES completion:nil];
}

- (void)setupKeyboardInputView
{
  UIView *accessoryInputView = self.accessoryKeyboardInputViewController.view;
  AssertTrueOrReturn(accessoryInputView);
  
  accessoryInputView.autoresizingMask = UIViewAutoresizingNone; // required for being able to change inputView height
  accessoryInputView.tw_height = self.initialInputViewHeight;
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
  AssertTrueOrReturn(self.keyboardNotificationsManager);
  
  [self.keyboardNotificationsManager setupKeyboardDidShowNotificationHandler:^(CGRect keyboardFrameRect) {
    defineStrongSelf();
    
    strongSelf.accessoryKeyboardInputViewController.view.tw_top = keyboardFrameRect.origin.y; // position instantly just below top of the keyboard
    [UIView animateWithDuration:kInputViewToKeyboardTopAnimationDuration animations:^{
      strongSelf.accessoryKeyboardInputViewController.view.tw_bottom = keyboardFrameRect.origin.y; // animate slide in
    }];
    CallBlock(strongSelf.keyboardDidShowBlock, keyboardFrameRect.size.height);
  }];
}

- (void)setupKeyboardWillHideNotificationHandler
{
  AssertTrueOrReturn(self.keyboardNotificationsManager);
  defineWeakSelf();
  
  [self.keyboardNotificationsManager setupKeyboardWillHideNotificationHandler:^{
    defineStrongSelf();
    
    strongSelf.accessoryKeyboardInputViewController.view.tw_bottom = [UIScreen tw_height]; // in here this will be animated automatically (with keyboard animation)
    CallBlock(strongSelf.keyboardWillHideBlock);
  }];
}

#pragma mark - public interface

- (void)slideInputViewIn {
  if (self.inputVC.view.superview != nil) {
    // If previous animation (most likely SlideOut) haven't finished yet, kill it
    [self.inputVC.view.layer removeAllAnimations];
  }

  if (self.inputVC.view.superview == nil) {
    [self installInputViewInKeyWindow];
  }

  self.inputViewSlidOut = YES;
  [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
    self.inputVC.view.tw_bottom = [UIScreen tw_height];
  }];
}

- (void)slideInputViewOut {
  [self slideInputViewOutAnimated:YES];
}

- (void)slideInputViewOutNotAnimated {
  [self slideInputViewOutAnimated:NO];
}

- (CGFloat)inputViewHeight
{
  return self.initialInputViewHeight;
}

#pragma mark - private

- (void)installInputViewInKeyWindow {
  UIViewController *parentVC = [UIWindow tw_keyWindow].rootViewController;
  if (parentVC.presentedViewController) {
    parentVC = parentVC.presentedViewController; // modal view
  }

  AssertTrueOrReturn(parentVC);
  AssertTrueOrReturn(self.inputVC.view.superview == nil);
  
  [parentVC willMoveToParentViewController:parentVC];
  [parentVC.view addSubview:self.inputVC.view];
  [parentVC didMoveToParentViewController:parentVC];
  
  [self positionInputViewBelowTheScreen];
}

- (void)positionInputViewBelowTheScreen
{
  self.inputVC.view.tw_width = [UIScreen tw_width];
  self.inputVC.view.tw_bottom = [UIScreen tw_height] + self.inputVC.view.tw_height;
}

#pragma mark - Sliding view out

- (void)slideInputViewOutAnimated:(BOOL)animated {
  __strong UIView *strongInputView = self.accessoryKeyboardInputViewController.view; // we want to prolong this object lifetime to ensure completion block gets executed!
  AssertTrueOr(self.initialInputViewHeight > 0,);

  defineWeakSelf();
  [self slideInputViewOutAnimated:animated completion:^(BOOL finished) {
    weakSelf.inputViewSlidOut = NO;
    if (finished) {
      [strongInputView removeFromSuperview];
      CallBlock(weakSelf.inputViewDidDismissBlock);
    }
  }];
}

- (void)slideInputViewOutAnimated:(BOOL)animated completion:(BlockWithBoolParameter)completion
{
  UIViewController *inputVC = self.inputVC;
  AssertTrueOrReturn(inputVC);

  VoidBlock positionUpdateBlock = ^{
      self.accessoryKeyboardInputViewController.view.tw_bottom = [UIScreen tw_height] + self.initialInputViewHeight;
  };

  BlockWithBoolParameter internalCompletion = ^(BOOL finished) {
    CallBlock(completion, finished);
    [inputVC didMoveToParentViewController:nil];
    if (finished) {
      [inputVC removeFromParentViewController];
    }
  };

  [inputVC willMoveToParentViewController:nil];

  if (animated) {
    [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
      positionUpdateBlock();
    } completion:internalCompletion];
  } else {
    positionUpdateBlock();
    internalCompletion(true);
  }
}

#pragma mark - Convenience accessors

- (UIViewController *)inputVC {
  return self.accessoryKeyboardInputViewController;
}

@end
