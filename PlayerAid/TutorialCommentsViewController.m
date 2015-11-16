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
#import "AddCommentInputViewController.h"
#import "UsersFetchController.h"
#import "CommentsContainerViewController.h"

typedef NS_ENUM(NSInteger, CommentsViewState) {
  CommentsViewStateFolded,
  CommentsViewStateExpanded,
};

static NSString * const kXibFileName = @"TutorialComments";
static const CGFloat kKeyboardInputViewHeight = 60.0f;

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CommentsViewState state;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (strong, nonatomic) AddCommentInputViewController *addCommentInputViewController;

// TODO: @property (weak, nonatomic) CommentsContainerViewController;

// temp, will be removed (or at least hidden) later - just to be able to easily hook up to the responder chain for now
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@end

@implementation TutorialCommentsViewController

#pragma mark - Init

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"Tutorial property is mandatory",);
  
  self.commentsBar.backgroundColor = [ColorsHelper tutorialCommentsBarBackgroundColor];
  [self setupCommentsController];
  [self refreshCommentsCountLabel];
  [self setupGestureRecognizer];
  [self setupKeyboardInputView];
  
  [self fold];
  [self invokeDidChangeHeightCallback];
}

- (void)setupCommentsController
{
  defineWeakSelf();
  self.commentsController = [[TutorialCommentsController alloc] initWithTutorial:self.tutorial commentsCountChangedBlock:^{
    [weakSelf refreshCommentsCountLabel];
  }];
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
  AddCommentInputViewController *inputVC = [[AddCommentInputViewController alloc] initWithUser:currentUser];
  inputVC.view.autoresizingMask = UIViewAutoresizingNone; // required for being able to change inputView height
  inputVC.view.tw_height = kKeyboardInputViewHeight;

  self.addCommentInputViewController = inputVC;
  self.inputTextField.inputView = self.addCommentInputViewController.view;
}

#pragma mark - Setters

- (void)setTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(!self.tutorial && @"Can't reinitialize self.tutorial");
  _tutorial = tutorial;
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
    [self fold];
    [self invokeDidChangeHeightCallback];
  }
  else {
    AssertTrueOrReturn(@"unhandled condition");
  }
}

- (void)expand
{
  self.view.tw_height = 300.0;
  self.state = CommentsViewStateExpanded;
  
  [self.inputTextField becomeFirstResponder];
}

- (void)fold
{
  self.view.tw_height = 150.0;
  self.state = CommentsViewStateFolded;
  
  [self.inputTextField resignFirstResponder];
}

- (void)invokeDidChangeHeightCallback
{
  CallBlock(self.didChangeHeightBlock, self.view);
}

#pragma mark - UI Updates

- (void)refreshCommentsCountLabel
{
  NSInteger commentsCount = self.tutorial.hasComments.count;
  self.commentsCountLabel.text = [NSString stringWithFormat:@"%lu Comments", commentsCount];
}

@end
