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
static const CGFloat kOpenCommentsToNavbarOffset = 100.0f;

static const CGFloat kKeyboardMakeCommentAccessoryInputViewHeight = 50.0f;
static CGFloat kKeyboardEditCommentAccessoryInputViewHeight = 70.0f;

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
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
  
  DISPATCH_ASYNC_ON_MAIN_THREAD(^{
    // Technical debt: I don't know why it doesn't set the correct height when I don't delay this operation...
    [self foldAnimated:NO];
    [self invokeDidChangeHeightCallback];
  });
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

#pragma mark - Fold/Expand

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

- (void)expand
{
  CallBlock(self.willExpandBlock);
  
  CGFloat desiredHeight = ([UIScreen tw_height] - self.navbarHeight - kOpenCommentsToNavbarOffset);
  self.view.tw_height = desiredHeight;
  self.state = CommentsViewStateExpanded;
  [self.arrowImageView tw_setRotationRadians:0];
  
  [self.makeCommentInputViewHandler slideInputViewIn];
  [self addCommentsTableViewToScreenBottomOffset];
}

- (void)foldAnimated:(BOOL)animated
{
  CGFloat commentsBarHeight = self.commentsBarHeightConstraint.constant;
  AssertTrueOr(commentsBarHeight > 0.0f,);
  
  VoidBlock heightUpdateBlock = ^() {
    [self removeCommentsTableViewToScreenBottomOffset];
    self.view.tw_height = commentsBarHeight;
    [self invokeDidChangeHeightCallback];
  };
  
  if (animated) {
    defineWeakSelf();
    [UIView animateWithDuration:kFoldingAnimationDuration animations:^{
      heightUpdateBlock();
      [self.view layoutIfNeeded];
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
  self.commentsContainerBottomOffsetConstraint.constant = 0.0f;
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
  NSPredicate *notReportedPredicte = [NSPredicate predicateWithFormat:@"reportedByUser == 0"];
  NSOrderedSet *notReportedComments = [self.tutorial.hasCommentsSet filteredOrderedSetUsingPredicate:notReportedPredicte];
  return [notReportedComments count];
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
    [commentsContainerVC setTutorialCommentsController:self.commentsController];
    [commentsContainerVC setTutorial:self.tutorial];
    
    defineWeakSelf();
    commentsContainerVC.isAnyCommentBeingEditedOrAddedBlock = ^BOOL() {
      BOOL anyCommentBeingEdited = weakSelf.editCommentInputViewHandler.inputViewVisible;
      BOOL newCommentBeingAdded = [weakSelf.makeCommentInputVC isInputTextViewFirstResponder];
      return (anyCommentBeingEdited || newCommentBeingAdded);
    };
    
    commentsContainerVC.isCommentBeingEditedBlock = ^BOOL(TutorialComment *comment) {
      return [weakSelf.editCommentInputVC.comment isEqual:comment];
    };
    
    commentsContainerVC.resignMakeOrEditCommentFirstResponderBlock = ^() {
      [weakSelf.editCommentInputVC hideKeyboard];
      [weakSelf.makeCommentInputVC hideKeyboard];
    };
    
    [commentsContainerVC setEditCommentActionSheetOptionSelectedBlock:^(TutorialComment *comment, BlockWithBoolParameter completion){
      [weakSelf.editCommentInputViewHandler slideInputViewIn];
      [weakSelf.editCommentInputVC setComment:comment];
      
      weakSelf.editCommentInputViewHandler.inputViewDidDismissBlock = ^() {
        BOOL commentChanged = YES; // TODO: update this value to whether it really changed or not
        CallBlock(completion, commentChanged);
      };
      
      weakSelf.editCommentInputVC.saveButtonAction = ^(NSString *editedComment) {
        // TODO: send a network request for editing a comment...
      };
    }];
  }
}

@end
