//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import BlocksKit;
#import "TutorialCommentsViewController.h"
#import "ColorsHelper.h"
#import "TutorialCommentsController.h"

typedef NS_ENUM(NSInteger, CommentsViewState) {
  CommentsViewStateFolded,
  CommentsViewStateExpanded,
};

static NSString * const kXibFileName = @"TutorialComments";

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CommentsViewState state;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@end

@implementation TutorialCommentsViewController

#pragma mark - Init

- (nonnull instancetype)initWithTutorial:(nonnull Tutorial *)tutorial
{
  self = [super initWithNibName:kXibFileName bundle:nil];
  if (self) {
    _tutorial = tutorial;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.commentsBar.backgroundColor = [ColorsHelper tutorialCommentsBarBackgroundColor];
  [self setupCommentsController];
  [self refreshCommentsCountLabel];
  [self setupGestureRecognizer];
  
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
}

- (void)fold
{
  self.view.tw_height = 150.0;
  self.state = CommentsViewStateFolded;
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
