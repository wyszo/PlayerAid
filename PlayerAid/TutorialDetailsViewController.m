//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "TutorialDetailsViewController.h"
#import "TutorialTableViewCell.h"
#import "TutorialsTableDataSource.h"
#import "TutorialCellHelper.h"
#import "TutorialStepsDataSource.h"
#import "ApplicationViewHierarchyHelper.h"
#import "CommonViews.h"
#import "VideoPlayer.h"
#import "TutorialDetailsHelper.h"
#import "TutorialComment.h"
#import "TutorialCommentsController.h"
#import "TutorialCommentsViewController.h"
#import "ViewControllersFactory.h"

static const CGFloat kOpenCommentsToNavbarOffset = 100.0f;

@interface TutorialDetailsViewController () <TutorialStepTableViewCellDelegate>
@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VideoPlayer *videoPlayer;
@property (strong, nonatomic) TutorialCommentsViewController *commentsViewController;
@end

@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"tutorial property is mandatory",);
  
  [self setupLazyInitializers];
  [self setupNavigationBarButtons];
  [self setupTableView];
  [self setupTableViewHeader];
  [self setupTableViewFooter];
  [self setupTutorialStepsTableView];
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

- (void)dealloc
{
  CallBlock(self.onDeallocBlock);
}

- (void)setupNavigationBarButtons
{
  if (self.tutorial.isPublished) {
    self.navigationItem.rightBarButtonItem = [[TutorialDetailsHelper new] reportTutorialBarButtonItem:self.tutorial];
  }
}

- (void)setupLazyInitializers
{
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
  CGFloat navbarHeight = [self.navigationController.navigationBar tw_bottom];
  [commentsVC setNavbarScreenHeight:navbarHeight];
  
  defineWeakSelf();
  commentsVC.didChangeHeightBlock = ^(UIView *commentsView, BOOL shouldScrollToComments) {
    weakSelf.tableView.tableFooterView = commentsView; // required for tableView to recognize and react to footer size change
    if (shouldScrollToComments) {
      [self scrollToCommentsBarAnimated:NO]; // animation handled externally, this is just a single animation step
    }
  };
  UIView *footerView = commentsVC.view;
  self.tableView.tableFooterView = footerView;
  
  self.commentsViewController = commentsVC;
}

- (void)setupTutorialStepsTableView
{
  AssertTrueOrReturn(self.tutorial);
  self.tutorialStepsDataSource = [[TutorialStepsDataSource alloc] initWithTableView:self.tableView tutorial:self.tutorial context:nil allowsEditing:NO tutorialStepTableViewCellDelegate:self];
  self.tutorialStepsDataSource.moviePlayerParentViewController = self;
}

- (TutorialsTableDataSource *)headerTableViewDataSource
{
  if (!_headerTableViewDataSource) {
    _headerTableViewDataSource = [[TutorialsTableDataSource alloc] initAttachingToTableView:self.headerTableView];
    AssertTrueOrReturnNil(self.tutorial);
    _headerTableViewDataSource.predicate = [NSPredicate predicateWithFormat:@"self == %@", self.tutorial];
    _headerTableViewDataSource.userAvatarOrNameSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:self backButtonActionBlock:nil allowPushingLoggedInUser:NO];
    
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
