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
  }
  return self;
}

- (void)setupKeyboardInputView
{
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  MakeCommentInputViewController *inputVC = [[MakeCommentInputViewController alloc] initWithUser:currentUser];
  inputVC.view.autoresizingMask = UIViewAutoresizingNone; // required for being able to change inputView height
  inputVC.view.tw_height = kKeyboardAccessoryInputViewHeight;
  
  self.makeCommentInputViewController = inputVC;
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
  [UIView animateWithDuration:kInputViewSlideInOutAnimationDuration animations:^{
    self.makeCommentInputViewController.view.tw_bottom = [UIScreen tw_height] + kKeyboardAccessoryInputViewHeight;
  } completion:^(BOOL finished) {
    [self.makeCommentInputViewController.view removeFromSuperview];
  }];
}

- (void)installInputViewInKeyWindow
{
  [[UIWindow tw_keyWindow] addSubview:self.inputVC.view];
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

@end
