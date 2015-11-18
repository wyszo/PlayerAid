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
static NSString * const kCommentsContainerEmbedSegueId = @"CommentsContainerSegue";

static const CGFloat kKeyboardInputViewHeight = 60.0f;

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsBarHeightConstraint;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CGFloat navbarHeight;
@property (assign, nonatomic) CommentsViewState state;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) AddCommentInputViewController *addCommentInputViewController;

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
  [self refreshAllCommentsLabels];
  [self setupGestureRecognizer];
  [self setupKeyboardInputView];
  
  DISPATCH_ASYNC_ON_MAIN_THREAD(^{
    // Technical debt: I don't know why it doesn't set the correct height when I don't delay this operation...
    [self fold];
    [self invokeDidChangeHeightCallback];
  });
}

- (void)setupCommentsController
{
  defineWeakSelf();
  self.commentsController = [[TutorialCommentsController alloc] initWithTutorial:self.tutorial commentsCountChangedBlock:^{
    [weakSelf refreshAllCommentsLabels];
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
    [self fold];
    [self invokeDidChangeHeightCallback];
  }
  else {
    AssertTrueOrReturn(@"unhandled condition");
  }
}

- (void)expand
{
  CGFloat desiredHeight = ([UIScreen tw_height] - self.navbarHeight);
  self.view.tw_height = desiredHeight;
  self.state = CommentsViewStateExpanded;
  [self.arrowImageView tw_setRotationRadians:0];
  
  [self.inputTextField becomeFirstResponder];
}

- (void)fold
{
  CGFloat commentsBarHeight = self.commentsBarHeightConstraint.constant;
  AssertTrueOr(commentsBarHeight > 0.0f,);
  self.view.tw_height = commentsBarHeight;
  self.state = CommentsViewStateFolded;
  [self.arrowImageView tw_setRotationRadians:M_PI];
  
  [self.inputTextField resignFirstResponder];
}

- (void)invokeDidChangeHeightCallback
{
  CallBlock(self.didChangeHeightBlock, self.view);
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

#pragma mark - Auxiliary methods

- (NSInteger)commentsCount
{  
  return self.tutorial.hasComments.count;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:kCommentsContainerEmbedSegueId]) {
    CommentsContainerViewController *commentsContainerVC = segue.destinationViewController;
    [commentsContainerVC setTutorial:self.tutorial];
  }
}

@end
