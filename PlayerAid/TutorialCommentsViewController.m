//
//  PlayerAid
//

@import UIKit;
@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;

#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "TutorialCommentsViewController_Debug.h"
#import "ColorsHelper.h"
#import "TutorialCommentsController.h"
#import "MakeCommentInputViewController.h"
#import "CommentsContainerViewController.h"
#import "KeyboardCustomAccessoryInputViewHandler.h"
#import "TutorialComment.h"
#import "KeyboardMakeEditCommentInputAccessoryViewsManager.h"
#import "EditCommentInputViewController.h"
#import "KeyboardInputConstants.h"
#import "PlayerAid-Swift.h"

typedef NS_ENUM(NSInteger, CommentsViewState) {
  CommentsViewStateFolded,
  CommentsViewStateExpanded,
};

static NSString * const kCommentsContainerEmbedSegueId = @"CommentsContainerSegue";

static const CGFloat kFoldingExpandingAnimationDuration = 0.5f;
static const CGFloat kCommentsViewHeightForNoCommentsState = 360.0f;

static const CGFloat kGapBelowCommentsToCompensateForOpenKeyboardSize = 271.0f; // Technical debt: it should NOT be hardcoded - 271 is the tallest keyboard right now (iPhone 6+ with text predictions enabled)

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) CommentsContainerViewController *commentsContainerVC;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CommentsViewState state;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) CommentsCountLabelFormatter *commentsCountLabelFormatter;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsContainerBottomOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsBarHeightConstraint;

@property (strong, nonatomic) KeyboardMakeEditCommentInputAccessoryViewsManager *keyboardInputViewsManager;
@end

@implementation TutorialCommentsViewController

#pragma mark - Init

- (void)viewDidLoad {
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"mandatory property (tutorial)",);
  AssertTrueOr(self.parentNavigationController && @"mandatory property (parentNavigationController), can't push other views without it",);
  
  self.commentsBar.backgroundColor = [ColorsHelper tutorialCommentsBarBackgroundColor];
  self.commentsCountLabelFormatter = [[CommentsCountLabelFormatter alloc] initWithFontSize:self.commentsLabel.font.pointSize];
  [self updateCommentsCountLabel];
  [self setupGestureRecognizer];
  [self setupKeyboardInputViewsManager];
  
  [self foldAnimated:NO];
  AssertTrueOrReturn(self.parentTableViewScrollAnimatedBlock && @"Without parent scroll animated block, scrolling to show currently edited comment won't work");
  AssertTrueOrReturn(self.parentTableViewFooterTopBlock && @"ParentTableViewFooterTopBlock is required for offsets calculations");
}

- (void)dealloc {
  [self.keyboardInputViewsManager dismissAllInputViews];
}

- (void)setupGestureRecognizer
{
  defineWeakSelf();
  UITapGestureRecognizer *gestureRecognizer = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    [weakSelf toggleFoldedInvokeCallbacks];
  } delay:0.0];
  [self.commentsBar addGestureRecognizer:gestureRecognizer];
}

- (void)setupKeyboardInputViewsManager {
  defineWeakSelf();
  self.keyboardInputViewsManager = [[KeyboardMakeEditCommentInputAccessoryViewsManager alloc] initWithAreCommentsExpandedBlock:^BOOL() {
      return (weakSelf.state == CommentsViewStateExpanded);
  }];

  self.keyboardInputViewsManager.makeACommentButtonPressedBlock = ^(NSString *text, BlockWithBoolParameter completion) {
      BlockWithBoolParameter internalCompletion = ^(BOOL success) {
          CallBlock(completion, success);
          if (success) {
            CallBlock(weakSelf.didMakeACommentBlock, nil);
          }
      };
      [weakSelf.commentsController sendACommentWithText:text completion:internalCompletion];
  };
}

#pragma mark - View visibility

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.keyboardInputViewsManager slideInActiveInputViewIfCommentsExpanded];
}

#pragma mark - Keyboard input methods forwarding

// TODO: this definitely needs unit tests to ensure the implementation doesn't break

- (id)forwardingTargetForSelector:(SEL)aSelector  {
  return self.keyboardInputViewsManager;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  BOOL respondsToSelector = [super respondsToSelector:aSelector];
  if (!respondsToSelector) {
    respondsToSelector = [self.keyboardInputViewsManager respondsToSelector:aSelector];
  }
  return respondsToSelector;
}


#pragma mark - LayoutSubviews

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  if (self.state == CommentsViewStateFolded) {
    /**
     Bugfix: earlier initial comment state was incorrect. When comment initially folded, it height was reduced to 49, but
     then on layoutSubviews (which happens automatically due to NavigationBar hiding) it was increased to 113, allowing
     to see the first comment below the folded comments bar
     */
    [self setViewHeightToCommentsBarHeight];
  }
  else {
    [self updateCommentsHeightIfExpandedShouldScrollToCommentsBar:NO];
  }
}

#pragma mark - Setters

- (void)setTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(!self.tutorial && (BOOL)(@"Can't reinitialize self.tutorial"));
  _tutorial = tutorial;
}

#pragma mark - Footer size calculations

- (void)recalculateSize {
  [self.view setNeedsLayout];
  [self.view layoutIfNeeded];
}

- (CGFloat)calculateDesiredTotalCommentsTableViewFooterHeight
{
  AssertTrueOr(self.commentsContainerVC.commentsTableView != nil,);
  [self.view layoutIfNeeded]; // ensures tableView contentSize is up to date

  CGFloat contentSizeHeight = self.commentsContainerVC.commentsTableView.contentSize.height;
  AssertTrueOr(contentSizeHeight > 0,);
  if (!self.tutorial.hasAnyPublishedComments) {
    contentSizeHeight = kCommentsViewHeightForNoCommentsState;
  } else if (self.shouldCompensateForOpenKeyboard) {
    contentSizeHeight += kGapBelowCommentsToCompensateForOpenKeyboardSize;
  }

  CGFloat commentsBarHeight = self.commentsBarHeightConstraint.constant;
  AssertTrueOr(commentsBarHeight > 0,);
  return (contentSizeHeight + kKeyboardMakeCommentAccessoryInputViewHeight + commentsBarHeight);
}

#pragma mark - DEBUG

- (void)DEBUG_expandComments {
  [self expandAnimated];
}

#pragma mark - Fold/Expand

- (void)foldAnimated:(BOOL)animated
{
  [self.keyboardInputViewsManager resetState];

  VoidBlock heightUpdateBlock = ^() {
    [self resetCommentsTableViewToScreenBottomOffset];
    [self setViewHeightToCommentsBarHeight];
    [self.arrowImageView tw_setRotationRadians:(CGFloat)M_PI];
    [self.view layoutIfNeeded];
    [self invokeDidChangeHeightCallbackShouldScrollToCommentsBar:NO];
  };

  self.state = CommentsViewStateFolded;

  if (animated) {
    [UIView animateWithDuration:kFoldingExpandingAnimationDuration animations:^{
      heightUpdateBlock();
        [self.keyboardInputViewsManager dismissAllInputViews];
    } completion:^(BOOL finished) {
      if (finished) {
        CallBlock(self.didFoldBlock);
      }
    }];
  }
  else {
    heightUpdateBlock();
    [self.keyboardInputViewsManager dismissAllInputViews];
    CallBlock(self.didFoldBlock);
  }
}

- (void)expandAnimated
{
  CallBlock(self.willExpandBlock);
  self.state = CommentsViewStateExpanded;

  [UIView animateWithDuration:kFoldingExpandingAnimationDuration animations:^{
    [self.arrowImageView tw_setRotationRadians:0];
    [self.keyboardInputViewsManager.makeCommentInputViewHandler slideInputViewIn];
    [self updateCommentsHeightIfExpandedShouldScrollToCommentsBar:YES];
  } completion:^(BOOL finished) {
    if (finished) {
      CallBlock(self.didExpandBlock);
    }
  }];
}

- (void)updateCommentsHeightIfExpandedShouldScrollToCommentsBar:(BOOL)shouldScroll
{
  if (self.state == CommentsViewStateExpanded) {
    [self updateCommentsTableViewToScreenBottomOffset];
    self.view.tw_height = [self calculateDesiredTotalCommentsTableViewFooterHeight];
    [self invokeDidChangeHeightCallbackShouldScrollToCommentsBar:shouldScroll];
  }
}

- (void)toggleFoldedInvokeCallbacks
{
  if (self.state == CommentsViewStateFolded) {
    [self expandAnimated];
  }
  else if (self.state == CommentsViewStateExpanded) {
    [self foldAnimated:YES];
  }
  else {
    AssertTrueOrReturn(@"unhandled condition");
  }
}

- (void)invokeDidChangeHeightCallbackShouldScrollToCommentsBar:(BOOL)shouldScroll
{
  CallBlock(self.didChangeHeightBlock, self.view, shouldScroll);
}

- (void)updateCommentsTableViewToScreenBottomOffset
{
  CGFloat inputViewHeight = self.keyboardInputViewsManager.makeCommentInputViewHandler.inputViewHeight;
  AssertTrueOrReturn(inputViewHeight > 0);
  self.commentsContainerBottomOffsetConstraint.constant = inputViewHeight;
}

- (void)resetCommentsTableViewToScreenBottomOffset
{
  AssertTrueOrReturn(self.commentsContainerBottomOffsetConstraint);
  self.commentsContainerBottomOffsetConstraint.constant = 0.0f;
}

- (void)setViewHeightToCommentsBarHeight
{
  CGFloat commentsBarHeight = self.commentsBarHeightConstraint.constant;
  AssertTrueOr(commentsBarHeight > 0.0f,);
  self.view.tw_height = commentsBarHeight;
}

#pragma mark - UI Updates

- (void)updateCommentsCountLabel {
  self.commentsLabel.attributedText = [self.commentsCountLabelFormatter attributedTextForCommentsCount:self.commentsCount];
}

#pragma mark - Auxiliary methods

- (NSUInteger)commentsCount
{
  NSPredicate *notReportedPredicate = [NSPredicate predicateWithFormat:@"status == %d", CommentStatusPublished];
  NSOrderedSet *notReportedComments = [self.tutorial.hasCommentsSet filteredOrderedSetUsingPredicate:notReportedPredicate];
  return [notReportedComments count];
}

- (void)scrollToShowCommentAboveKeyboardInputBarWithRect:(CGRect)commentCellRect
{
  AssertTrueOr(self.parentTableViewFooterTopBlock && "Parameter required for offsets calculations",);
  CGFloat parentTableViewFooterTop = 0;
  if (self.parentTableViewFooterTopBlock) {
    parentTableViewFooterTop = self.parentTableViewFooterTopBlock();
  }

  CGFloat commentsBarBottom = parentTableViewFooterTop + (self.commentsBar.tw_top + self.commentsBarHeightConstraint.constant);
  CGFloat offsetToScrollTo = commentsBarBottom + (commentCellRect.origin.y + commentCellRect.size.height); // comment cell frame relative to parent

  AssertTrueOrReturn([self.keyboardInputViewsManager editCommentInputViewSlidOut]); // Technical Debt: this method assumes being called after showing editComment Keyboard input view...
  CGFloat inputViewHeight = self.keyboardInputViewsManager.editCommentInputVC.view.tw_height;
  CGFloat topOffsetToKeyboard = [UIScreen tw_height] - (kGapBelowCommentsToCompensateForOpenKeyboardSize + inputViewHeight); // distance from top of the screen to top of the inputView above keyboard predictions bar
  offsetToScrollTo -= topOffsetToKeyboard;

  AssertTrueOrReturn(self.parentTableViewScrollAnimatedBlock);
  CallBlock(self.parentTableViewScrollAnimatedBlock, offsetToScrollTo);
}

- (TutorialCommentsController *)commentsController
{
  if (!_commentsController) {
    AssertTrueOrReturnNil(self.tutorial && (BOOL)(@"Tutorial property is mandatory"));

    defineWeakSelf();
    _commentsController = [[TutorialCommentsController alloc] initWithTutorial:self.tutorial commentsCountChangedBlock:^{
        [weakSelf updateCommentsCountLabel];
        [weakSelf.commentsContainerVC commentsCountDidChange];
        [weakSelf.view layoutIfNeeded];
    }];
  }
  return _commentsController;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // TODO: move all this code to a separate CommentsContainerVC Configurator object

  if ([segue.identifier isEqualToString:kCommentsContainerEmbedSegueId]) {
    CommentsContainerViewController *commentsContainerVC = segue.destinationViewController;

    self.commentsContainerVC = commentsContainerVC;

    [commentsContainerVC setTutorialCommentsController:self.commentsController];
    [commentsContainerVC setTutorial:self.tutorial];
    commentsContainerVC.parentNavigationController = self.parentNavigationController;
    
    defineWeakSelf();
    commentsContainerVC.isAnyCommentBeingEditedOrAddedBlock = ^BOOL() {
      BOOL anyCommentBeingEdited = [weakSelf.keyboardInputViewsManager editCommentInputViewSlidOut];
      BOOL newCommentBeingAdded = [weakSelf.keyboardInputViewsManager.makeCommentInputVC isInputTextViewFirstResponder];
      return (anyCommentBeingEdited || newCommentBeingAdded);
    };
    
    commentsContainerVC.isCommentBeingEditedBlock = ^BOOL(TutorialComment *comment) {
      BOOL anyCommentBeingEdited = [weakSelf.keyboardInputViewsManager editCommentInputViewSlidOut];
      BOOL currentCommentBeingEdited = [weakSelf.keyboardInputViewsManager.editCommentInputVC.comment isEqual:comment];
      return (anyCommentBeingEdited && currentCommentBeingEdited);
    };
    
    commentsContainerVC.resignMakeOrEditCommentFirstResponderBlock = ^() {
      [weakSelf.keyboardInputViewsManager.editCommentInputVC hideKeyboard];
      [weakSelf.keyboardInputViewsManager.makeCommentInputVC hideKeyboard];
    };
    
    [commentsContainerVC setEditCommentActionSheetOptionSelectedBlock:^(TutorialComment *comment, CGRect tutorialCellFrame, VoidBlock completion) {
        [weakSelf.keyboardInputViewsManager slideEditCommentInputViewIn];
        weakSelf.keyboardInputViewsManager.editCommentInputViewDidDismissBlock = completion;

        [weakSelf.keyboardInputViewsManager.editCommentInputVC setComment:comment];
        [weakSelf.keyboardInputViewsManager.editCommentInputVC setInputViewToFirstResponder];
        [weakSelf scrollToShowCommentAboveKeyboardInputBarWithRect:tutorialCellFrame];

        weakSelf.keyboardInputViewsManager.editCommentInputVC.saveButtonAction = ^(NSString *editedComment) {
        if (editedComment.length > 0) {
          [weakSelf.commentsController editComment:comment withText:editedComment completion:^(NSError *error) {
            if (!error) {
              [weakSelf.keyboardInputViewsManager dismissEditCommentBar];
            }
          }];
        }
      };
    }];
  }
}

@end
