//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;
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

@interface TutorialDetailsViewController () <TutorialStepTableViewCellDelegate>
@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VideoPlayer *videoPlayer;

// temporary label, will be removed later
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@end

@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupLazyInitializers];
  [self setupNavigationBarButtons];
  [self setupTableView];
  [self setupTableViewHeader];
  [self setupTutorialStepsTableView];
  [self setupNumberOfCommentsCount];
}

- (void)dealloc
{
  CallBlock(self.onDeallocBlock);
}

- (void)setupNumberOfCommentsCount
{
  NSArray *comments = [self allComments];
  self.commentsCountLabel.text = [NSString stringWithFormat:@"%lu", comments.count];
  
  // TODO: wire up KVO on self.tutorial.hasComments property to trigger updating this! 
}

- (void)setupNavigationBarButtons
{
  self.navigationItem.rightBarButtonItem = [[TutorialDetailsHelper new] reportTutorialBarButtonItem:self.tutorial];
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

- (void)setupTutorialStepsTableView
{
  AssertTrueOrReturn(self.tutorial);
  self.tutorialStepsDataSource = [[TutorialStepsDataSource alloc] initWithTableView:self.tableView tutorial:self.tutorial context:nil allowsEditing:NO tutorialStepTableViewCellDelegate:self];
  self.tutorialStepsDataSource.moviePlayerParentViewController = self;
  self.tableView.tableFooterView = [CommonViews smallTableHeaderOrFooterView];
}

- (TutorialsTableDataSource *)headerTableViewDataSource
{
  if (!_headerTableViewDataSource) {
    _headerTableViewDataSource = [[TutorialsTableDataSource alloc] initAttachingToTableView:self.headerTableView];
    AssertTrueOrReturnNil(self.tutorial);
    _headerTableViewDataSource.predicate = [NSPredicate predicateWithFormat:@"self == %@", self.tutorial];
    _headerTableViewDataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:self backButtonActionBlock:nil allowPushingLoggedInUser:NO];
    
    _headerTableViewDataSource.didConfigureCellAtIndexPath = ^(TutorialTableViewCell *cell, NSIndexPath *indexPath) {
      [cell showGradientOverlay:YES];
     };
  }
  return _headerTableViewDataSource;
}

#pragma mark - Tutorial Comments

// TODO: extract this logic from here!
- (NSArray *)allComments
{
  AssertTrueOrReturnNil(self.tutorial);
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"belongsToTutorial == %@", self.tutorial];
  NSArray *comments = [TutorialComment MR_findAllWithPredicate:predicate inContext:self.tutorial.managedObjectContext];
  return comments;
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
