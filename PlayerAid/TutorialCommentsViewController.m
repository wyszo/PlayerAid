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
#import "TutorialComment.h"
#import "TutorialCommentCell.h"

typedef NS_ENUM(NSInteger, CommentsViewState) {
  CommentsViewStateFolded,
  CommentsViewStateExpanded,
};

static NSString * const kXibFileName = @"TutorialComments";
static NSString * const kTutorialCommentCellIdentifier = @"TutorialCommentCell";
static NSString * const kTutorialCommentXibName = @"TutorialCommentCell";
static const CGFloat kKeyboardInputViewHeight = 60.0f;

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) Tutorial *tutorial;
@property (assign, nonatomic) CommentsViewState state;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (strong, nonatomic) AddCommentInputViewController *addCommentInputViewController;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) TWCoreDataTableViewDataSource *dataSource;

// temp, will be removed (or at least hidden) later - just to be able to easily hook up to the responder chain for now
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
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
  [self setupKeyboardInputView];
  [self setupCommentsTableView];
  
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

#pragma mark - TableView setup

- (void)setupCommentsTableView
{
  [self setupCommentsTableViewCells];
  [self setupCommentsTableViewDataSource];
}

- (void)setupCommentsTableViewCells
{
  [self.commentsTableView registerNibWithName:kTutorialCommentXibName forCellReuseIdentifier:kTutorialCommentCellIdentifier];
}

- (void)setupCommentsTableViewDataSource
{
  self.dataSource = [[TWCoreDataTableViewDataSource alloc] initWithCellReuseIdentifier:@"TutorialCommentCell" configureCellWithObjectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[TutorialCommentCell class]]);
    TutorialCommentCell *commentCell = (TutorialCommentCell *)cell;

    AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
    TutorialComment *comment = (TutorialComment *)object;
    [commentCell configureWithTutorialComment:comment];
  }];
  defineWeakSelf();
  self.dataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    defineStrongSelf();
    NSFetchRequest *fetchRequest = [TutorialComment MR_requestAllSortedBy:@"createdOn" ascending:YES];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"belongsToTutorial == %@", strongSelf.tutorial];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSFetchedResultsController *fetchedResultsController = [TutorialComment MR_fetchController:fetchRequest delegate:nil useFileCache:NO groupedBy:nil inContext:context];
    [fetchedResultsController tw_performFetchAssertResults];
    // TODO: introduce FetchResultsControllerBinder so that the comments UI is refreshed when new data comes in
    
    return fetchedResultsController;
  };
  self.commentsTableView.dataSource = self.dataSource;
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
