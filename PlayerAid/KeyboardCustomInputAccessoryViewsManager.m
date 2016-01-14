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
@property (copy, nonatomic) BoolReturningBlock areCommentsExpanded;
@property (assign, nonatomic) BOOL isEditViewActive;

@property (strong, nonatomic) MakeCommentInputViewController *makeCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *makeCommentInputViewHandler;

@property (strong, nonatomic) EditCommentInputViewController *editCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *editCommentInputViewHandler;
@end

@implementation KeyboardCustomInputAccessoryViewsManager

#pragma mark - Init

- (instancetype)initWithAreCommentsExpandedBlock:(BoolReturningBlock)areCommentsExpandedBlock {
  AssertTrueOrReturnNil(areCommentsExpandedBlock);

  self = [super init];
  if (self) {
    self.areCommentsExpanded = areCommentsExpandedBlock;
    [self setupKeyboardInputView];
  }
  return self;
}

- (void)setupKeyboardInputView
{
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  self.makeCommentInputVC = [[MakeCommentInputViewController alloc] initWithUser:currentUser];

  self.makeCommentInputViewHandler = [[KeyboardCustomAccessoryInputViewHandler alloc] initWithAccessoryKeyboardInputViewController:self.makeCommentInputVC
                                                                                                            desiredInputViewHeight:kKeyboardMakeCommentAccessoryInputViewHeight];
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
  if (self.editCommentInputViewHandler.inputViewSlidOut) {
    self.isEditViewActive = YES;

    [self.makeCommentInputViewHandler slideInputViewOutNotAnimated]; // still visible behind edit view, needs to be dismissed
    [self.editCommentInputViewHandler slideInputViewOut];
  } else if (self.makeCommentInputViewHandler.inputViewSlidOut) {
    self.isEditViewActive = NO;
    [self dismissAllInputViews];
  }
}

- (void)slideInActiveInputViewIfCommentsExpanded {
  AssertTrueOrReturn(self.areCommentsExpanded);

  BOOL commentsExpanded = self.areCommentsExpanded();
  if (!commentsExpanded) {
    return;
  }

  [self.makeCommentInputViewHandler slideInputViewIn];

  if (self.isEditViewActive) {
    [self.editCommentInputViewHandler slideInputViewIn];
  }
}

- (void)resetState {
  self.isEditViewActive = NO;
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