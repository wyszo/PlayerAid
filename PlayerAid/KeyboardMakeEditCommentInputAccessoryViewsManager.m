//
// Created by Wyszo on 13/01/16.
//

@import KZAsserts;
@import TWCommonLib;
#import "KeyboardMakeEditCommentInputAccessoryViewsManager.h"
#import "UsersFetchController.h"
#import "MakeCommentInputViewController.h"
#import "KeyboardCustomAccessoryInputViewHandler.h"
#import "EditCommentInputViewController.h"
#import "KeyboardInputConstants.h"

@interface KeyboardMakeEditCommentInputAccessoryViewsManager ()
@property (copy, nonatomic) BoolReturningBlock areCommentsExpanded;
@property (assign, nonatomic) BOOL isEditViewActive;

@property (strong, nonatomic) MakeCommentInputViewController *makeCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *makeCommentInputViewHandler;

@property (strong, nonatomic) EditCommentInputViewController *editCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *editCommentInputViewHandler;
@end

@implementation KeyboardMakeEditCommentInputAccessoryViewsManager

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
                                                                                                            initialInputViewHeight:kKeyboardMakeCommentAccessoryInputViewHeight];
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

- (void)slideEditCommentInputViewIn {
  self.isEditViewActive = YES;
  [self.editCommentInputViewHandler slideInputViewIn];
}

- (BOOL)editCommentInputViewSlidOut {
  return [self.editCommentInputViewHandler inputViewSlidOut];
}

- (void)resetState {
  self.isEditViewActive = NO;
}

- (void)dismissEditCommentBar
{
  self.isEditViewActive = NO;
  [self.editCommentInputVC hideKeyboard];
  [self.editCommentInputViewHandler slideInputViewOut];
}

- (void)setEditCommentInputViewDidDismissBlock:(VoidBlock)editCommentInputViewDidDismissBlock {
  _editCommentInputViewDidDismissBlock = editCommentInputViewDidDismissBlock;
  self.editCommentInputViewHandler.inputViewDidDismissBlock = editCommentInputViewDidDismissBlock;
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
                                                                                                          initialInputViewHeight:kKeyboardEditCommentAccessoryInputViewHeight];
  }
  return _editCommentInputViewHandler;
}

@end