//
//  PlayerAid
//

@import KZAsserts;
#import <TWCommonLib/NSObject+TWLazyInitialization.h>
#import "TutorialDetailsViewController.h"
#import "TutorialTableViewCell.h"
#import "TutorialsTableDataSource.h"
#import "TutorialCellHelper.h"
#import "TutorialStepsDataSource.h"
#import "ApplicationViewHierarchyHelper.h"
#import "CommonViews.h"
#import "VideoPlayer.h"


@interface TutorialDetailsViewController () <TutorialStepTableViewCellDelegate>

@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VideoPlayer *videoPlayer;

@end


@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupLazyInitializers];
  [self setupTableView];
  [self setupTableViewHeader];
  [self setupTutorialStepsTableView];
}

- (void)dealloc
{
  CallBlock(self.onDeallocBlock);
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
      [cell showGradientOverlay:NO]; // turned off for now, change to YES when you want to use gradient view
     };
  }
  return _headerTableViewDataSource;
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
