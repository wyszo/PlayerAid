//
//  PlayerAid
//

@import UIKit;
@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;

#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "TutorialCommentsViewController.h"
#import "ColorsHelper.h"
#import "TutorialCommentsController.h"
#import "MakeCommentInputViewController.h"
#import "CommentsContainerViewController.h"
#import "KeyboardCustomAccessoryInputViewHandler.h"
#import "UsersFetchController.h"
#import "TutorialComment.h"
#import "EditCommentInputViewController.h"

typedef NS_ENUM(NSInteger, CommentsViewState) {
  CommentsViewStateFolded,
  CommentsViewStateExpanded,
};

static NSString * const kCommentsContainerEmbedSegueId = @"CommentsContainerSegue";

static const CGFloat kFoldingExpandingAnimationDuration = 0.5f;
static const CGFloat kCommentsViewHeightForNoCommentsState = 360.0f;

static const CGFloat kGapBelowCommentsToCompensateForOpenKeyboardSize = 271.0f; // Technical debt: it should NOT be hardcoded - 271 is the tallest keyboard right now (iPhone 6+ with text predictions enabled)
static const CGFloat kKeyboardMakeCommentAccessoryInputViewHeight = 50.0f;
static CGFloat kKeyboardEditCommentAccessoryInputViewHeight = 70.0f;

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) CommentsContainerViewController *commentsContainerVC;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CommentsViewState state;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsContainerBottomOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsBarHeightConstraint;

@property (strong, nonatomic) MakeCommentInputViewController *makeCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *makeCommentInputViewHandler;

@property (strong, nonatomic) EditCommentInputViewController *editCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *editCommentInputViewHandler;
@end

@implementation TutorialCommentsViewController

#pragma mark - Init

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"mandatory property (tutorial)",);
  AssertTrueOr(self.parentNavigationController && @"mandatory property (parentNavigationController), can't push other views without it",);
  
  self.commentsBar.backgroundColor = [ColorsHelper tutorialCommentsBarBackgroundColor];
  [self refreshAllCommentsLabels];
  [self setupGestureRecognizer];
  [self setupKeyboardInputView];
  
  [self foldAnimated:NO];
  AssertTrueOrReturn(self.parentTableViewScrollAnimatedBlock && @"Without parent scroll animated block, scrolling to show currently edited comment won't work");
  AssertTrueOrReturn(self.parentTableViewFooterTopBlock && @"ParentTableViewFooterTopBlock is required for offsets calculations");
}

- (void)dealloc
{
  [self dismissAllInputViews];
}

- (void)dismissAllInputViews
{
  [self.makeCommentInputViewHandler slideInputViewOut];
  [self.editCommentInputViewHandler slideInputViewOut];
}

- (void)setupGestureRecognizer
{
  defineWeakSelf();
  UITapGestureRecognizer *gestureRecognizer = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    [weakSelf toggleFoldedInvokeCallbacks];
  } delay:0.0];
  [self.commentsBar addGestureRecognizer:gestureRecognizer];
}

- (void)setupKeyboardInputView
{
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  self.makeCommentInputVC = [[MakeCommentInputViewController alloc] initWithUser:currentUser];
  
  self.makeCommentInputViewHandler = [[KeyboardCustomAccessoryInputViewHandler alloc] initWithAccessoryKeyboardInputViewController:self.makeCommentInputVC desiredInputViewHeight:kKeyboardMakeCommentAccessoryInputViewHeight];
  
  defineWeakSelf();
  self.makeCommentInputVC.postButtonPressedBlock = ^(NSString *text, BlockWithBoolParameter completion) {
    BlockWithBoolParameter internalCompletion = ^(BOOL success) {
        CallBlock(completion, success);
        if (success) {
          CallBlock(weakSelf.didMakeACommentBlock, nil);
        }
    };
    [weakSelf.commentsController sendACommentWithText:text completion:internalCompletion];
  };
}

#pragma mark - LayoutSubviews

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  if (self.state == CommentsViewStateFolded) {
    /**
     Bugfix: earlier initial comment state was incorrect. When comment initially folded, it height was reduced to 49, but then on layoutSubviews (which happens automatically due to NavigationBar hiding) it was increased to 113, allowing to see the first comment below the folded comments bar
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

#pragma mark - Fold/Expand

- (void)foldAnimated:(BOOL)animated
{
  VoidBlock heightUpdateBlock = ^() {
    [self removeCommentsTableViewToScreenBottomOffset];
    [self setViewHeightToCommentsBarHeight];
    [self.arrowImageView tw_setRotationRadians:(CGFloat)M_PI];
    [self.view layoutIfNeeded];
    [self invokeDidChangeHeightCallbackShouldScrollToCommentsBar:NO];
  };

  self.state = CommentsViewStateFolded;

  if (animated) {
    [UIView animateWithDuration:kFoldingExpandingAnimationDuration animations:^{
      heightUpdateBlock();
      [self.makeCommentInputViewHandler slideInputViewOut];
    } completion:^(BOOL finished) {
      if (finished) {
        CallBlock(self.didFoldBlock);
      }
    }];
  }
  else {
    heightUpdateBlock();
    [self.makeCommentInputViewHandler slideInputViewOut];
    CallBlock(self.didFoldBlock);
  }
}

- (void)expandAnimated
{
  CallBlock(self.willExpandBlock);
  self.state = CommentsViewStateExpanded;

  [UIView animateWithDuration:kFoldingExpandingAnimationDuration animations:^{
    [self.arrowImageView tw_setRotationRadians:0];
    [self.makeCommentInputViewHandler slideInputViewIn];
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
    [self addCommentsTableViewToScreenBottomOffset]; // update bottom offset between comments table bottom and makeComment inputView
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

- (void)addCommentsTableViewToScreenBottomOffset
{
  CGFloat inputViewHeight = self.makeCommentInputViewHandler.inputViewHeight;
  AssertTrueOrReturn(inputViewHeight > 0);
  self.commentsContainerBottomOffsetConstraint.constant = inputViewHeight;
}

- (void)removeCommentsTableViewToScreenBottomOffset
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

- (void)refreshAllCommentsLabels
{
  [self refreshCommentsCountLabel];
  [self refreshCommentsLabel];
}

- (void)refreshCommentsCountLabel
{
  NSString *numberOfCommentsString = @"";
  if (self.commentsCount) {
    numberOfCommentsString = [NSString stringWithFormat:@"%tu", self.commentsCount];
  }
  self.commentsCountLabel.text = numberOfCommentsString;
}

- (void)refreshCommentsLabel
{
  NSString *sufix = @"";
  if (self.commentsCount != 1) {
    sufix = @"s";
  }
  self.commentsLabel.text = [NSString stringWithFormat:@"Comment%@", sufix];
}

#pragma mark - Lazy initialization

- (TutorialCommentsController *)commentsController
{
  if (!_commentsController) {
    AssertTrueOrReturnNil(self.tutorial && (BOOL)(@"Tutorial property is mandatory"));

    defineWeakSelf();
    _commentsController = [[TutorialCommentsController alloc] initWithTutorial:self.tutorial commentsCountChangedBlock:^{
      [weakSelf refreshAllCommentsLabels];
      [weakSelf.commentsContainerVC commentsCountDidChange];
      [weakSelf.view layoutIfNeeded];
    }];
  }
  return _commentsController;
}

#pragma mark - Auxiliary methods

- (NSUInteger)commentsCount
{
  NSPredicate *notReportedPredicate = [NSPredicate predicateWithFormat:@"status == %d", CommentStatusPublished];
  NSOrderedSet *notReportedComments = [self.tutorial.hasCommentsSet filteredOrderedSetUsingPredicate:notReportedPredicate];
  return [notReportedComments count];
}

- (void)dismissEditCommentBar
{
  [self.editCommentInputVC hideKeyboard];
  [self.editCommentInputViewHandler slideInputViewOut];
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

  AssertTrueOrReturn([self.editCommentInputViewHandler inputViewSlidOut]); // Technical Debt: this method assumes being called after showing editComment Keyboard input view...
  CGFloat inputViewHeight = self.editCommentInputVC.view.tw_height;
  CGFloat topOffsetToKeyboard = [UIScreen tw_height] - (kGapBelowCommentsToCompensateForOpenKeyboardSize + inputViewHeight); // distance from top of the screen to top of the inputView above keyboard predictions bar
  offsetToScrollTo -= topOffsetToKeyboard;

  AssertTrueOrReturn(self.parentTableViewScrollAnimatedBlock);
  CallBlock(self.parentTableViewScrollAnimatedBlock, offsetToScrollTo);
}

#pragma mark - Lazy Initialization

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
    _editCommentInputViewHandler = [[KeyboardCustomAccessoryInputViewHandler alloc] initWithAccessoryKeyboardInputViewController:self.editCommentInputVC desiredInputViewHeight:kKeyboardEditCommentAccessoryInputViewHeight];
  }
  return _editCommentInputViewHandler;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:kCommentsContainerEmbedSegueId]) {
    CommentsContainerViewController *commentsContainerVC = segue.destinationViewController;
    self.commentsContainerVC = commentsContainerVC;
    [commentsContainerVC setTutorialCommentsController:self.commentsController];
    [commentsContainerVC setTutorial:self.tutorial];
    commentsContainerVC.parentNavigationController = self.parentNavigationController;
    
    defineWeakSelf();
    commentsContainerVC.isAnyCommentBeingEditedOrAddedBlock = ^BOOL() {
      BOOL anyCommentBeingEdited = weakSelf.editCommentInputViewHandler.inputViewSlidOut;
      BOOL newCommentBeingAdded = [weakSelf.makeCommentInputVC isInputTextViewFirstResponder];
      return (anyCommentBeingEdited || newCommentBeingAdded);
    };
    
    commentsContainerVC.isCommentBeingEditedBlock = ^BOOL(TutorialComment *comment) {
      BOOL anyCommentBeingEdited = weakSelf.editCommentInputViewHandler.inputViewSlidOut;
      BOOL currentCommentBeingEdited = [weakSelf.editCommentInputVC.comment isEqual:comment];
      return (anyCommentBeingEdited && currentCommentBeingEdited);
    };
    
    commentsContainerVC.resignMakeOrEditCommentFirstResponderBlock = ^() {
      [weakSelf.editCommentInputVC hideKeyboard];
      [weakSelf.makeCommentInputVC hideKeyboard];
    };
    
    [commentsContainerVC setEditCommentActionSheetOptionSelectedBlock:^(TutorialComment *comment, CGRect tutorialCellFrame, VoidBlock completion) {
        [weakSelf.editCommentInputViewHandler slideInputViewIn];
        weakSelf.editCommentInputViewHandler.inputViewDidDismissBlock = completion;

        [weakSelf.editCommentInputVC setComment:comment];
        [weakSelf.editCommentInputVC setInputViewToFirstResponder];
        [weakSelf scrollToShowCommentAboveKeyboardInputBarWithRect:tutorialCellFrame];

        weakSelf.editCommentInputVC.saveButtonAction = ^(NSString *editedComment) {
        if (editedComment.length > 0) {
          [weakSelf.commentsController editComment:comment withText:editedComment completion:^(NSError *error) {
            if (!error) {
              [weakSelf dismissEditCommentBar];
            }
          }];
        }
      };
    }];
  }
}

@end
