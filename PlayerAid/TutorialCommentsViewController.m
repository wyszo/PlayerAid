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
#import "CommentsContainerViewController.h"
#import "MakeCommentKeyboardAccessoryInputViewHandler.h"

typedef NS_ENUM(NSInteger, CommentsViewState) {
  CommentsViewStateFolded,
  CommentsViewStateExpanded,
};

static NSString * const kXibFileName = @"TutorialComments";
static NSString * const kCommentsContainerEmbedSegueId = @"CommentsContainerSegue";

static const CGFloat kFoldingAnimationDuration = 0.5f;

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
@property (strong, nonatomic) MakeCommentKeyboardAccessoryInputViewHandler *makeCommentInputViewHandler;
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
    [self foldAnimated:NO];
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
  self.makeCommentInputViewHandler = [MakeCommentKeyboardAccessoryInputViewHandler new];
  AddCommentInputViewController *inputVC = self.makeCommentInputViewHandler.makeCommentInputViewController;
  defineWeakSelf();
  inputVC.postButtonPressedBlock = ^(NSString *text, BlockWithBoolParameter completion) {
    [weakSelf.commentsController sendACommentWithText:text completion:completion];
  };
  self.addCommentInputViewController = inputVC;
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
  
  CGFloat desiredHeight = ([UIScreen tw_height] - self.navbarHeight);
  self.view.tw_height = desiredHeight;
  self.state = CommentsViewStateExpanded;
  [self.arrowImageView tw_setRotationRadians:0];
  
  [self.makeCommentInputViewHandler slideInputViewIn];
}

- (void)foldAnimated:(BOOL)animated
{
  CGFloat commentsBarHeight = self.commentsBarHeightConstraint.constant;
  AssertTrueOr(commentsBarHeight > 0.0f,);
  
  VoidBlock heightUpdateBlock = ^() {
    self.view.tw_height = commentsBarHeight;
    [self invokeDidChangeHeightCallback];
  };
  
  if (animated) {
    [UIView animateWithDuration:kFoldingAnimationDuration animations:^{
      heightUpdateBlock();
      [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
      CallBlock(self.didFoldBlock);
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
