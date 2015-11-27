//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "MakeCommentKeyboardAccessoryInputViewHandler.h"
#import "UsersFetchController.h"
#import "User.h"
#import "MakeCommentInputViewController.h"

static const CGFloat kKeyboardAccessoryInputViewHeight = 50.0f;
static const CGFloat kInputViewSlideInOutAnimationDuration = 0.5f;

@interface MakeCommentKeyboardAccessoryInputViewHandler()
@property (nonatomic, strong) MakeCommentInputViewController *makeCommentInputViewController;
@end

@implementation MakeCommentKeyboardAccessoryInputViewHandler

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self setupKeyboardInputView];
    [self setupAccessoryKeyboardInputViewNotificationCallbacks];
  }
  return self;
}

- (void)dealloc
{
  [self slideInputViewOut];
}

- (void)setupKeyboardInputView
{
  MakeCommentInputViewController *inputVC = [[MakeCommentInputViewController alloc] initWithUser:self.currentUser];
  inputVC.view.autoresizingMask = UIViewAutoresizingNone; // required for being able to change inputView height
  inputVC.view.tw_height = kKeyboardAccessoryInputViewHeight;
  
  self.makeCommentInputViewController = inputVC;
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
    
    strongSelf.makeCommentInputViewController.view.tw_top = keyboardFrameRect.origin.y; // position instantly just below top of the keyboard
    [UIView animateWithDuration:kInputViewToKeyboardTopAnimationDuration animations:^{
      strongSelf.makeCommentInputViewController.view.tw_bottom = keyboardFrameRect.origin.y; // animate slide in
    }];
  }];
}

- (void)setupKeyboardWillHideNotificationHandler
{
  defineWeakSelf();
  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    weakSelf.makeCommentInputViewController.view.tw_bottom = [UIScreen tw_height]; // in here this will be animated automatically (with keyboard animation)
  }];
}

#pragma mark - public interface

- (void)slideInputViewIn
{
  AssertTrueOrReturn(self.inputVC.view.superview == nil);
  [self installInputViewInKeyWindow];
  
  [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
    self.inputVC.view.tw_bottom = [UIScreen tw_height];
  }];
}

- (void)slideInputViewOut
{
  __strong UIView *strongInputView = self.makeCommentInputViewController.view; // we want to prolong this object lifetime to ensure completion block gets executed!
  
  [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
    self.makeCommentInputViewController.view.tw_bottom = [UIScreen tw_height] + kKeyboardAccessoryInputViewHeight;
  } completion:^(BOOL finished) {
    [strongInputView removeFromSuperview];
  }];
}

- (void)installInputViewInKeyWindow
{
  UIViewController *parentVC = [UIWindow tw_keyWindow].rootViewController;
  AssertTrueOrReturn(parentVC);
  
  [parentVC.view addSubview:self.inputVC.view];
  [self positionInputViewBelowTheScreen];
}

#pragma mark - private

- (void)positionInputViewBelowTheScreen
{
  self.inputVC.view.tw_width = [UIScreen tw_width];
  self.inputVC.view.tw_bottom = [UIScreen tw_height] + self.inputVC.view.tw_height;
}

- (MakeCommentInputViewController *)inputVC
{
  return self.makeCommentInputViewController;
}

- (User *)currentUser
{
  return [[UsersFetchController sharedInstance] currentUser];
}

@end
