//
//  PlayerAid
//

@import UIKit;
@import KZAsserts;
@import TWCommonLib;
#import "TutorialDetailsViewController.h"
#import "TutorialTableViewCell.h"
#import "TutorialsTableDataSource.h"
#import "TutorialCellHelper.h"
#import "TutorialStepsDataSourceDelegate.h"
#import "ApplicationViewHierarchyHelper.h"
#import "CommonViews.h"
#import "VideoPlayer.h"
#import "TutorialDetailsHelper.h"
#import "TutorialCommentsViewController.h"
#import "TutorialCommentsViewController_Debug.h"
#import "ViewControllersFactory.h"
#import "TutorialsHelper.h"
#import "DebugSettings.h"
#import "PlayerAid-Swift.h"


static const CGFloat kOpenCommentsToNavbarOffset = 100.0f;

@interface TutorialDetailsViewController () <TutorialStepTableViewCellDelegate, UITableViewDelegate>
@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) TutorialStepsDataSourceDelegate *tutorialStepsDataSourceDelegate;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VideoPlayer *videoPlayer;
@property (strong, nonatomic) TutorialCommentsViewController *commentsViewController;
@property (strong, nonatomic) TWTableViewScrollHandlingDelegate *scrollDelegate;
@property (strong, nonatomic) CommentRepliesFetchController *commentRepliesFetchController;
@end

@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && (BOOL)(@"tutorial property is mandatory"),);
  
  [self setupLazyInitializers];
  [self setupNavigationBar];
  [self setupTableView];
  [self setupTableViewHeader];
  [self setupTableViewFooter];
  [self setupTutorialStepsTableView];
  [self setupKeyboardHandlers];

  self.navigationController.hidesBarsOnSwipe = YES;
  self.automaticallyAdjustsScrollViewInsets = NO; /* Doesn't help when we have transparent NavBar. Without it there's a problem with NavigationBar not being presented again when you scroll back up after making a comment */
  
  if (DEBUG_MODE_PUSH_COMMENT_REPLIES) {
    defineWeakSelf();
    DISPATCH_AFTER(0.5, ^{
        // DEBUG: open comments automatically
        [weakSelf.commentsViewController DEBUG_expandComments];
    });
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (!_commentRepliesFetchController) {
    AssertTrueOrReturn(self.tutorial);
    self.commentRepliesFetchController = [[CommentRepliesFetchController alloc] initWithTutorial:self.tutorial];
  }
  [self.commentRepliesFetchController start];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
  BOOL viewRemovedFromViewHierarchy = (parent == nil);
  if (viewRemovedFromViewHierarchy) {
    self.navigationController.hidesBarsOnSwipe = NO;
  }
  
  [self.commentsViewController dismissAllInputViews]; // called manually to ensure proper UI cleanup
}

- (void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self]; // deregister keyboard events
}

- (void)setupNavigationBar {
  self.title = @"Guide";
  
  if (self.tutorial.isPublished && ![TutorialsHelper isOwnTutorial:self.tutorial]) {
    self.navigationItem.rightBarButtonItem = [[TutorialDetailsHelper new] reportTutorialBarButtonItem:self.tutorial];
  }
}

- (void)setupLazyInitializers {
  self.videoPlayer = [[VideoPlayer tw_lazy] initWithParentViewController:self.navigationController];
}

- (void)setupTableView
{
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100.f;
}

- (void)setupTableViewHeader
{
  self.tableView.tableHeaderView = self.headerTableView;
  self.headerTableViewDataSource = self.headerTableViewDataSource;
}

- (void)setupTableViewFooter
{
  if (![self shouldShowComments]) {
    [self setupDummyTableFooterViewsToHideUnnecessarySeparators];
    return;
  }
  
  defineWeakSelf();
  TutorialCommentsViewController *commentsVC = [[ViewControllersFactory new] tutorialCommentsViewControllerFromStoryboardWithTutorial:self.tutorial];
  commentsVC.didPressReplyBlock = ^(TutorialComment *comment) {
    AssertTrueOrReturn(comment);
    [weakSelf.commentRepliesFetchController fetchAllButFirstPageForComment:comment];
  };
  commentsVC.parentNavigationController = self.navigationController;

  commentsVC.didChangeHeightBlock = ^(UIView *commentsView, BOOL shouldScrollToComments) {
    weakSelf.tableView.tableFooterView = commentsView; // required for tableView to recognize and react to footer size change
    if (shouldScrollToComments) {
      [weakSelf scrollToCommentsBarAnimated:NO]; // animation handled externally, this is just a single animation step
    }
  };
  commentsVC.didMakeACommentBlock = ^() {
    DISPATCH_AFTER(0.1, ^{ // slight delay is required, otherwise comments height won't be updated yet
        [weakSelf.tableView tw_scrollToBottom];
    });
  };
  commentsVC.parentTableViewScrollAnimatedBlock = ^(CGFloat offset) {
      [weakSelf.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
  };
  commentsVC.parentTableViewFooterTopBlock = ^() {
      return weakSelf.tableView.tableFooterView.tw_top;
  };

  UIView *footerView = commentsVC.view;
  self.tableView.tableFooterView = footerView;

  [self addChildViewController:commentsVC];
  [commentsVC didMoveToParentViewController:self];

  self.commentsViewController = commentsVC;
}

- (void)setupTutorialStepsTableView
{
  [self setupTutorialStepsDataSourceDelegate];
  [self setupScrollDelegate];
}

- (void)setupTutorialStepsDataSourceDelegate {
  AssertTrueOrReturn(self.tutorial);
  self.tutorialStepsDataSourceDelegate = [[TutorialStepsDataSourceDelegate alloc] initWithTableView:self.tableView
                                                                                           tutorial:self.tutorial
                                                                                            context:nil
                                                                                      allowsEditing:NO
                                                                  tutorialStepTableViewCellDelegate:self];
  self.tutorialStepsDataSourceDelegate.moviePlayerParentViewController = self;
}

- (void)setupScrollDelegate {
  NSError *error;
  self.scrollDelegate = [[TWTableViewScrollHandlingDelegate alloc] initWithTableView:self.tableView fallbackDelegate:(id)self.tutorialStepsDataSourceDelegate error:&error];
  AssertTrueOrReturn(!error);

  defineWeakSelf();
  self.scrollDelegate.didScrollAboveFooter = ^() {
    [weakSelf.commentsViewController slideOutActiveInputViewIfCommentsExpanded];
  };
  self.scrollDelegate.didScrollToFooter = ^() {
    [weakSelf.commentsViewController slideInActiveInputViewIfCommentsExpanded];
  };
}

- (TutorialsTableDataSource *)headerTableViewDataSource
{
  if (!_headerTableViewDataSource) {
    _headerTableViewDataSource = [[TutorialsTableDataSource alloc] initAttachingToTableView:self.headerTableView];
    AssertTrueOrReturnNil(self.tutorial);
    _headerTableViewDataSource.predicate = [NSPredicate predicateWithFormat:@"self == %@", self.tutorial];
    _headerTableViewDataSource.userAvatarOrNameSelectedBlock = [ApplicationViewHierarchyHelper pushProfileVCFromNavigationController:self.navigationController
                                                                                                            allowPushingLoggedInUser:NO];
    
    _headerTableViewDataSource.didConfigureCellAtIndexPath = ^(TutorialTableViewCell *cell, NSIndexPath *indexPath) {
      [cell showGradientOverlay:YES];
     };
  }
  return _headerTableViewDataSource;
}

- (BOOL)shouldShowComments
{
  AssertTrueOrReturnNo(self.tutorial);
  return [self.tutorial isPublished];
}

- (void)setupDummyTableFooterViewsToHideUnnecessarySeparators
{
  AssertTrueOrReturn(self.tableView);
  self.tableView.tableFooterView = [CommonViews smallTableHeaderOrFooterView];
}

#pragma mark - Keyboard handling

- (void)setupKeyboardHandlers {

  defineWeakSelf();
  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *notification) {
      weakSelf.commentsViewController.shouldCompensateForOpenKeyboard = YES;
      [weakSelf.commentsViewController recalculateSize];
  }];

  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *notification) {
      weakSelf.commentsViewController.shouldCompensateForOpenKeyboard = NO;
      DISPATCH_ASYNC_ON_MAIN_THREAD(^{ // Technical debt: without this artificial delay,
          // size calculation is incorrect and the gap below comments remains
          // after hiding a keyboard (after editing a comment)
          [weakSelf.commentsViewController recalculateSize];
      });
  }];
}

#pragma mark - Auxiliary methods

- (void)scrollToCommentsBarAnimated:(BOOL)animated
{
  AssertTrueOrReturn(self.tableView.tableFooterView);
  
  CGFloat yOffset = (self.tableView.tableFooterView.tw_top - kOpenCommentsToNavbarOffset);
  yOffset = MAX(0, yOffset);
  [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:animated];
}

#pragma mark - Lazy Initalization

- (UITableView *)headerTableView
{
  if (!_headerTableView) {
    CGFloat cellHeight = [[TutorialCellHelper new] cellHeightForCurrentScreenWidthWithBottomGapVisible:NO];
    CGRect frame = CGRectMake(0, 0, 0, cellHeight);
    _headerTableView = [[UITableView alloc] initWithFrame:frame];
    
    _headerTableView.allowsSelection = NO;
    _headerTableView.scrollEnabled = NO;
  }
  return _headerTableView;
}

#pragma mark - TutorialStepTableViewCellDelegate

- (void)didPressPlayVideoWithURL:(NSURL *)url
{
  AssertTrueOrReturn(url);
  [self.videoPlayer presentMoviePlayerAndPlayVideoURL:url];
}

@end
