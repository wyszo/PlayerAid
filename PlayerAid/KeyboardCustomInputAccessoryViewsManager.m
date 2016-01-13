//
// Created by Wyszo on 13/01/16.
//

@import KZAsserts;
@import TWCommonLib;
#import "KeyboardCustomInputAccessoryViewsManager.h"
#import "UsersFetchController.h"
#import "MakeCommentInputViewController.h"
#import "KeyboardCustomAccessoryInputViewHandler.h"
#import "EditCommentInputViewController.h"

const CGFloat kKeyboardMakeCommentAccessoryInputViewHeight = 50.0f;
static CGFloat kKeyboardEditCommentAccessoryInputViewHeight = 70.0f;

@interface KeyboardCustomInputAccessoryViewsManager ()
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *activeInputViewHandler;
@end

@implementation KeyboardCustomInputAccessoryViewsManager

- (void)setup {
  [self setupKeyboardInputView];
}

- (void)setupKeyboardInputView
{
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  self.makeCommentInputVC = [[MakeCommentInputViewController alloc] initWithUser:currentUser];

  self.makeCommentInputViewHandler = [[KeyboardCustomAccessoryInputViewHandler alloc] initWithAccessoryKeyboardInputViewController:self.makeCommentInputVC
                                                                                                            desiredInputViewHeight:kKeyboardMakeCommentAccessoryInputViewHeight];

  // TODO: need to override a setter, since this can be changed later on
  self.makeCommentInputVC.postButtonPressedBlock = self.makeACommentButtonPressedBlock;
}

#pragma mark - Setters

- (void)setMakeACommentButtonPressedBlock:(void (^)(NSString *, BlockWithBoolParameter))makeACommentButtonPressedBlock {
  _makeACommentButtonPressedBlock = makeACommentButtonPressedBlock;
  self.makeCommentInputVC.postButtonPressedBlock = _makeACommentButtonPressedBlock;
}

#pragma mark - Public

- (void)dismissAllInputViews {
  [self.makeCommentInputViewHandler slideInputViewOut];
  [self.editCommentInputViewHandler slideInputViewOut];
}

- (void)slideOutActiveInputViewIfCommentsExpanded {
  // ok - make comment view is always visible
  // question is - whether editInputView is also visible at a particular time

  if (self.editCommentInputViewHandler.inputViewSlidOut) {
    self.activeInputViewHandler = self.editCommentInputViewHandler;

    // in this case we want to dismiss makeComment input view without animation instantly
    // and editCommentInputView normally

    // bug: when keyboard visible and edit is wired up as a keyboard input view, dismissing it
    // reveals make comment for a second

  } else if (self.makeCommentInputViewHandler.inputViewSlidOut) {
    // (watch out: make comment input view might be slid out even when editCommentView is active)
    self.activeInputViewHandler = self.makeCommentInputViewHandler;

    // in this case we just want to dismiss both views normally
  }
  [self dismissAllInputViews];
}

- (void)slideInActiveInputViewIfCommentsExpanded {
  AssertTrueOrReturn(self.areCommentsExpanded);

  BOOL commentsExpanded = self.areCommentsExpanded();
  if (!commentsExpanded) {
    return;
  }

  [self.makeCommentInputViewHandler slideInputViewIn];

  // that's some misleading variable naming...
  if (self.activeInputViewHandler == self.editCommentInputViewHandler) {
    [self.activeInputViewHandler slideInputViewIn];
  }

  // the whole logic will break if trying to make a long comment and then starting to edit a comment!
  // make comment bar will be visible from behind edit input view bar
  // nope - but only because make comment view shrinks when the keyboard is dismissed
}

- (void)resetState {
  self.activeInputViewHandler = nil;
}

- (void)dismissEditCommentBar
{
  [self.editCommentInputVC hideKeyboard];
  [self.editCommentInputViewHandler slideInputViewOut];
}

#pragma mark - Lazy initialization

- (EditCommentInputViewController *)editCommentInputVC
{
  if (!_editCommentInputVC) {
    _editCommentInputVC = [EditCommentInputViewController new];

    defineWeakSelf();
    _editCommentInputVC.cancelButtonAction = ^() {
        [weakSelf.editCommentInputViewHandler slideInputViewOut];
    };
  }
  return _editCommentInputVC;
}

- (KeyboardCustomAccessoryInputViewHandler *)editCommentInputViewHandler
{
  if (!_editCommentInputViewHandler) {
    _editCommentInputViewHandler = [[KeyboardCustomAccessoryInputViewHandler alloc] initWithAccessoryKeyboardInputViewController:self.editCommentInputVC
                                                                                                          desiredInputViewHeight:kKeyboardEditCommentAccessoryInputViewHeight];
  }
  return _editCommentInputViewHandler;
}

@end