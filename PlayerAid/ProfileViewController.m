//
//  PlayerAid
//

#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"
#import "ColorsHelper.h"
#import "ShowOverlayViewWhenTutorialsTableEmptyBehaviour.h"
#import "PlayerInfoSegmentedControlButtonView.h"
#import "ApplicationViewHierarchyHelper.h"
#import "AppDelegate.h"


static const NSUInteger kSegmentedControlHeight = 54.0f;
static const NSUInteger kPlayerInfoViewHeight = 310;
static const NSUInteger kDistanceBetweenPlayerInfoAndFirstTutorial = 18;


@interface ProfileViewController () <TutorialsTableViewDelegate>

@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;
@property (weak, nonatomic) PlayerInfoSegmentedControlButtonView *tutorialsFilterButtonView;

@property (nonatomic, strong) ShowOverlayViewWhenTutorialsTableEmptyBehaviour *tableViewOverlayBehaviour;

@end


@implementation ProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if (!self.user) {
    self.user = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"loggedInUser == 1"]];
  }
  AssertTrueOrReturn(self.user);
  
  [self setupTutorialsTableDataSource];
  [self setupTableHeaderView];
  self.playerInfoView.user = self.user;
  
  self.noTutorialsLabel.text = @"You haven't created any tutorials yet!";
  self.tableViewOverlayBehaviour = [[ShowOverlayViewWhenTutorialsTableEmptyBehaviour alloc] initWithTableView:self.tutorialTableView tutorialsDataSource:self.tutorialsTableDataSource overlayView:self.noTutorialsLabel allowScrollingWhenNoCells:NO];
  
  [self hideTabBarBadge];
}

- (void)hideTabBarBadge
{
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.tabBarControllerHandler hideProfileTabBarItemBadge];
}

- (void)setupTutorialsTableDataSource
{
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.tutorialTableView];
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"createdBy = %@ AND state != %@", self.user, kTutorialStateUnsaved];
  self.tutorialsTableDataSource.groupBy = @"state";
  self.tutorialsTableDataSource.showSectionHeaders = YES;
  self.tutorialsTableDataSource.tutorialTableViewDelegate = self;
  self.tutorialsTableDataSource.swipeToDeleteEnabled = YES;
  
  __weak typeof(self) weakSelf = self;
  self.tutorialsTableDataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewControllerBlock:weakSelf allowPushingLoggedInUser:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateFilterViewTutorialsCount];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - Header View initialization

- (void)setupTableHeaderView
{
  NSUInteger windowWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
  
  self.playerInfoView = [[PlayerInfoView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, kPlayerInfoViewHeight)];
  
  CGRect containerFrame = CGRectMake(0, 0, windowWidth, kPlayerInfoViewHeight + kSegmentedControlHeight + kDistanceBetweenPlayerInfoAndFirstTutorial);
  UIView *containerView = [self wrapView:self.playerInfoView inAContainerViewWithFrame:containerFrame];
  
  UIView *segmentedControl = [self flatSegmentedControlWithYOffset:kPlayerInfoViewHeight width:windowWidth];
  [containerView addSubview:segmentedControl];
  
  self.tutorialTableView.tableHeaderView = containerView;
}

- (UIView *)flatSegmentedControlWithYOffset:(CGFloat)yOffset width:(CGFloat)width
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, width, kSegmentedControlHeight)];
  view.backgroundColor = [ColorsHelper tutorialsUnselectedFilterButtonColor];
  
  PlayerInfoSegmentedControlButtonView *segmentedControlButton = [[PlayerInfoSegmentedControlButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, kSegmentedControlHeight)];
  [view addSubview:segmentedControlButton];
  self.tutorialsFilterButtonView = segmentedControlButton;
  
  return view;
}

- (UIView *)wrapView:(UIView *)view inAContainerViewWithFrame:(CGRect)frame
{
  UIView *containerView = [[UIView alloc] initWithFrame:frame];
  containerView.backgroundColor = [UIColor whiteColor];
  [containerView addSubview:view];
  return containerView;
}

#pragma mark - Tutorials Table View Delegate

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  // no action, required method
}

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows
{
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
  [self updateFilterViewTutorialsCount];
}

- (void)updateFilterViewTutorialsCount
{
  NSInteger publishedCount = [self.tutorialsTableDataSource numberOfRowsForSectionNamed:@"Published"];
  NSString *publishedCountString = [@(publishedCount) stringValue];
  self.tutorialsFilterButtonView.topLabel.text = publishedCountString;
  
  NSString *bottomTitle = (publishedCount == 1 ? @"Tutorial" : @"Tutorials");
  self.tutorialsFilterButtonView.bottomLabel.text = bottomTitle;
}

@end
