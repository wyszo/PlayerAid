//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import AFNetworking;
#import "TimelineViewController.h"
#import "GuidesTableDataSource.h"
#import "TutorialDetailsViewController.h"
#import "ColorsHelper.h"
#import "ProfileViewController.h"
#import "ApplicationViewHierarchyHelper.h"
#import "DebugSettings.h"
#import "VideoPlayer.h"
#import "TutorialDetailsHelper.h"
#import "ImagesPrefetchingController.h"

@interface TimelineViewController () <TutorialsTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *latestFilterBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *followingFilterBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *latestFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *followingFilterButton;

@property (strong, nonatomic) GuidesTableDataSource *guidesTableDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tutorialsTableView;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;

@property (weak, nonatomic) Tutorial *lastSelectedTutorial;

@property (nonatomic, strong) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (nonatomic, strong) ImagesPrefetchingController *imagesPrefetchingController;
@property (nonatomic, strong) VideoPlayer *videoPlayer;

@end


@implementation TimelineViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.title = @"Latest Guides";
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Guides" style:UIBarButtonItemStylePlain target:nil action:nil];
  
  self.videoPlayer = [[VideoPlayer tw_lazy] initWithParentViewController:self.tabBarController];
  
  [self setupDataSource];
  [self setupTableViewHeader];
  
  self.imagesPrefetchingController = [[ImagesPrefetchingController alloc] initWithDataSource:self.guidesTableDataSource tableView:self.tutorialsTableView];
  
  self.noTutorialsLabel.text = @"No tutorials to show yet";
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.tutorialsTableView dataSource:self.guidesTableDataSource overlayView:self.noTutorialsLabel allowScrollingWhenNoCells:NO];

  // TODO: Technical debt - we definitely shouldn't delay UI skinning like that!
  [self selectFilterLatest]; // intentional
  defineWeakSelf();
  DISPATCH_AFTER(0.01, ^{
    [weakSelf selectFilterLatest];
  });
  
  // TODO: Filter buttons should be extracted to a separate class!! // We can also use UIStackView on iOS9

  if (DEBUG_MODE_PUSH_COMMENT_REPLIES) {
    DISPATCH_AFTER(0.5, ^{
        // automatically enter first tutorial
        [weakSelf DEBUG_PUSH_TUTORIAL_DETAILS];
    });
  }
}

- (void)DEBUG_PUSH_TUTORIAL_DETAILS {
  Tutorial* tutorial = [self.guidesTableDataSource tutorialAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  AssertTrueOrReturn(tutorial);

  self.lastSelectedTutorial = tutorial;
  [[TutorialDetailsHelper new] performTutorialDetailsSegueFromViewController:self];
}

- (void)setupDataSource
{
  self.guidesTableDataSource = [[GuidesTableDataSource alloc] initWithTableView:self.tutorialsTableView];
  [self.guidesTableDataSource attachDataSourceAndDelegateToTableView];
  self.guidesTableDataSource.predicate = [NSPredicate predicateWithFormat:@"state == %@ AND reportedByUser == 0", kTutorialStatePublished];
  self.guidesTableDataSource.tutorialTableViewDelegate = self;
  self.guidesTableDataSource.userAvatarOrNameSelectedBlock = [ApplicationViewHierarchyHelper pushProfileVCFromNavigationController:self.navigationController allowPushingLoggedInUser:NO];
}

- (void)setupTableViewHeader
{
  // table view header - a white stripe in this case
  const CGFloat kHeaderGapHeight = 18.0f;
  UIView *headerViewGap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kHeaderGapHeight)];
  self.tutorialsTableView.tableHeaderView = headerViewGap;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - latest & following buttons bar

- (IBAction)latestFilterSelected:(id)sender
{
  // TODO: change predicate to show latest tutorials
  
  [self selectFilterLatest];
}

- (void)selectFilterLatest
{
  [self setLatestFilterButtonTextColor:[ColorsHelper tutorialsSelectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsSelectedFilterButtonColor]];
  [self setFollowingFilterButtonTextColor:[ColorsHelper tutorialsUnselectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsUnselectedFilterButtonColor]];
}

- (IBAction)followingFilterSelected:(id)sender
{
  // TODO: change predicate to show tutorials of the users I follow
  
  [self selectFilterFollowing];
}

- (void)selectFilterFollowing
{
  [self setLatestFilterButtonTextColor:[ColorsHelper tutorialsUnselectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsUnselectedFilterButtonColor]];
  [self setFollowingFilterButtonTextColor:[ColorsHelper tutorialsSelectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsSelectedFilterButtonColor]];
}

- (void)setLatestFilterButtonTextColor:(UIColor *)latestColor andFollowingFilterButtonTextColor:(UIColor *)followingColor
{
  self.latestFilterButton.titleLabel.textColor = latestColor;
  self.followingFilterButton.titleLabel.textColor = followingColor;
}

- (void)setLatestFilterButtonTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
  self.latestFilterButton.titleLabel.textColor = textColor;
  self.latestFilterBackgroundView.backgroundColor = backgroundColor;
}

- (void)setFollowingFilterButtonTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
  self.followingFilterButton.titleLabel.textColor = textColor;
  self.followingFilterBackgroundView.backgroundColor = backgroundColor;
}

#pragma mark - TutorialTableViewDelegate

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  if ([self isDuringSegueTransition]) {
    return; // prevents from pushing details view controller multiple times when tapping multiple times
  }
  
  self.lastSelectedTutorial = tutorial;
  [[TutorialDetailsHelper new] performTutorialDetailsSegueFromViewController:self];
}

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows
{
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

- (void)willDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn(self.imagesPrefetchingController);
  [self.imagesPrefetchingController willDisplayCellForRowAtIndexPath:indexPath];
}

- (void)didEndDisplayingCellForRowAtIndexPath:(NSIndexPath *)indexPath withTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(self.imagesPrefetchingController);
  [self.imagesPrefetchingController didEndDisplayingCellForRowAtIndexPath:indexPath withTutorial:tutorial];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [[TutorialDetailsHelper new] prepareForTutorialDetailsSegue:segue pushingTutorial:self.lastSelectedTutorial];
}

#pragma mark - Private

- (BOOL)isDuringSegueTransition {
  return (self.navigationController.topViewController != self);
}

@end
