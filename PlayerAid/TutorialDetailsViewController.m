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
#import "ViewControllersFactory.h"
#import "TutorialsHelper.h"

static const CGFloat kOpenCommentsToNavbarOffset = 100.0f;

@interface TutorialDetailsViewController () <TutorialStepTableViewCellDelegate, UITableViewDelegate>
@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) TutorialStepsDataSourceDelegate *tutorialStepsDataSourceDelegate;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VideoPlayer *videoPlayer;
@property (strong, nonatomic) TutorialCommentsViewController *commentsViewController;
@property (strong, nonatomic) TWTableViewScrollHandlingDelegate *scrollDelegate;
@end

@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && (BOOL)(@"tutorial property is mandatory"),);
  
  [self setupLazyInitializers];
  [self setupNavigationBarButtons];
  [self setupTableView];
  [self setupTableViewHeader];
  [self setupTableViewFooter];
  [self setupTutorialStepsTableView];
  [self setupKeyboardHandlers];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.hidesBarsOnSwipe = NO;
  
  [self.commentsViewController dismissAllInputViews]; // called manually to ensure proper UI cleanup
}

- (void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self]; // deregister keyboard events
}

- (void)setupNavigationBarButtons {
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
  
  TutorialCommentsViewController *commentsVC = [[ViewControllersFactory new] tutorialCommentsViewControllerFromStoryboardWithTutorial:self.tutorial];
  commentsVC.parentNavigationController = self.navigationController;
  defineWeakSelf();

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
