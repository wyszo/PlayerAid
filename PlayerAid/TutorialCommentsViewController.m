//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import BlocksKit;
@import MagicalRecord;
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

static NSString * const kXibFileName = @"TutorialComments";
static NSString * const kCommentsContainerEmbedSegueId = @"CommentsContainerSegue";

static const CGFloat kFoldingAnimationDuration = 0.5f;

static const CGFloat kKeyboardMakeCommentAccessoryInputViewHeight = 50.0f;
static CGFloat kKeyboardEditCommentAccessoryInputViewHeight = 70.0f;

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) CommentsContainerViewController *commentsContainerVC;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CGFloat navbarHeight;
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
  AssertTrueOr(self.tutorial && @"Tutorial property is mandatory",);
  
  self.commentsBar.backgroundColor = [ColorsHelper tutorialCommentsBarBackgroundColor];
  [self refreshAllCommentsLabels];
  [self setupGestureRecognizer];
  [self setupKeyboardInputView];
  
  [self foldAnimated:NO];
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
    [weakSelf.commentsController sendACommentWithText:text completion:completion];
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
}

#pragma mark - Setters

- (void)setTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(!self.tutorial && @"Can't reinitialize self.tutorial");
  _tutorial = tutorial;
}

- (void)setNavbarScreenHeight:(CGFloat)navbarHeight
{
  _navbarHeight = navbarHeight;
}

#pragma mark - Footer size calculations

- (CGFloat)calculateDesiredTotalCommentsTableViewFooterHeight
{
  AssertTrueOr(self.commentsContainerVC.commentsTableView != nil,);
  
  CGFloat contentSizeHeight = self.commentsContainerVC.commentsTableView.contentSize.height;
  CGFloat commentsBarHeight = self.commentsBarHeightConstraint.constant;
  AssertTrueOr(commentsBarHeight > 0,);
  return contentSizeHeight + kKeyboardMakeCommentAccessoryInputViewHeight + commentsBarHeight;
}

#pragma mark - Fold/Expand

- (void)foldAnimated:(BOOL)animated
{
  VoidBlock heightUpdateBlock = ^() {
    [self removeCommentsTableViewToScreenBottomOffset];
    [self setViewHeightToCommentsBarHeight];
    [self.view layoutIfNeeded];
    [self invokeDidChangeHeightCallback];
  };
  
  if (animated) {
    defineWeakSelf();
    [UIView animateWithDuration:kFoldingAnimationDuration animations:^{
      heightUpdateBlock();
    } completion:^(BOOL finished) {
      CallBlock(weakSelf.didFoldBlock);
    }];
  }
  else {
    heightUpdateBlock();
    CallBlock(self.didFoldBlock);
  }
  
  self.state = CommentsViewStateFolded;
  [self.arrowImageView tw_setRotationRadians:M_PI];
  
  [self.makeCommentInputViewHandler slideInputViewOut];
}

- (void)expand
{
  CallBlock(self.willExpandBlock);
  
  self.view.tw_height = [self calculateDesiredTotalCommentsTableViewFooterHeight];
  self.state = CommentsViewStateExpanded;
  [self.arrowImageView tw_setRotationRadians:0];
  
  [self.makeCommentInputViewHandler slideInputViewIn];
  [self addCommentsTableViewToScreenBottomOffset];
}

- (void)toggleFoldedInvokeCallbacks
{
  if (self.state == CommentsViewStateFolded) {
    [self expand];
    [self invokeDidChangeHeightCallback];
    CallBlock(self.didExpandBlock);
  }
  else if (self.state == CommentsViewStateExpanded) {
    [self foldAnimated:YES];
  }
  else {
    AssertTrueOrReturn(@"unhandled condition");
  }
}

- (void)invokeDidChangeHeightCallback
{
  CallBlock(self.didChangeHeightBlock, self.view);
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
    numberOfCommentsString = [NSString stringWithFormat:@"%lu", self.commentsCount];
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
    AssertTrueOrReturnNil(self.tutorial && @"Tutorial property is mandatory");
    
    defineWeakSelf();
    _commentsController = [[TutorialCommentsController alloc] initWithTutorial:self.tutorial commentsCountChangedBlock:^{
      [weakSelf refreshAllCommentsLabels];
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
    
    [commentsContainerVC setEditCommentActionSheetOptionSelectedBlock:^(TutorialComment *comment, VoidBlock completion){
      [weakSelf.editCommentInputViewHandler slideInputViewIn]; 
      weakSelf.editCommentInputViewHandler.inputViewDidDismissBlock = completion;
      
      [weakSelf.editCommentInputVC setComment:comment];
      [weakSelf.editCommentInputVC setInputViewToFirstResponder];
      
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
