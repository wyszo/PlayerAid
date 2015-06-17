//
//  PlayerAid
//

#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"
#import "ColorsHelper.h"
#import "ApplicationViewHierarchyHelper.h"
#import "TabBarBadgeHelper.h"
#import "EditProfileViewController.h"
#import "EditProfileFilterCollectionViewController.h"


static const NSUInteger kFilterCollectionViewHeight = 54.0f;
static const NSUInteger kPlayerInfoViewHeight = 310;
static const NSUInteger kDistanceBetweenPlayerInfoAndFirstTutorial = 18;


@interface ProfileViewController () <TutorialsTableViewDelegate>

@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;
@property (strong, nonatomic) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (strong, nonatomic) EditProfileFilterCollectionViewController *filterCollectionViewController;

@end


@implementation ProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setupUserIfNotNil];
  [self setupTutorialsTableDataSource];
  [self setupTableHeaderView];
  [self setupPlayerInfoView];
  
  self.noTutorialsLabel.text = @"You haven't created any tutorials yet!";
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.tutorialTableView dataSource:self.tutorialsTableDataSource overlayView:self.noTutorialsLabel allowScrollingWhenNoCells:NO];
  
  if (DEBUG_MODE_PUSH_EDIT_PROFILE) {
    [self presentEditProfileViewController];
  }
}

- (void)setupUserIfNotNil
{
  if (!self.user) {
    [self forceFetchUser];
  }
  AssertTrueOrReturn(self.user);
}

- (void)forceFetchUser
{
  self.user = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"loggedInUser == 1"]];
}

- (void)setupTutorialsTableDataSource
{
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initAttachingToTableView:self.tutorialTableView];
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"createdBy = %@ AND state != %@", self.user, kTutorialStateUnsaved];
  self.tutorialsTableDataSource.groupBy = @"state";
  self.tutorialsTableDataSource.showSectionHeaders = YES;
  self.tutorialsTableDataSource.tutorialTableViewDelegate = self;
  self.tutorialsTableDataSource.swipeToDeleteEnabled = YES;
  self.tutorialsTableDataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:self allowPushingLoggedInUser:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[TabBarBadgeHelper new] hideProfileTabBarItemBadge];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self updateFilterViewTutorialsCount];
}

#pragma mark - Header View initialization

- (void)setupPlayerInfoView
{
  defineWeakSelf();
  self.playerInfoView.editButtonPressed = ^() {
    [weakSelf presentEditProfileViewController];
  };
  self.playerInfoView.user = self.user;
}

- (void)setupTableHeaderView
{
  NSUInteger windowWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
  self.playerInfoView = [[PlayerInfoView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, kPlayerInfoViewHeight)];
  
  CGRect containerFrame = CGRectMake(0, 0, windowWidth, kPlayerInfoViewHeight + kFilterCollectionViewHeight + kDistanceBetweenPlayerInfoAndFirstTutorial);
  UIView *containerView = [self.playerInfoView tw_wrapInAContainerViewWithFrame:containerFrame];
  
  [self addFilterCollectionViewControllerWithSize:CGSizeMake(windowWidth, kFilterCollectionViewHeight) toContainerView:containerView];
  
  self.tutorialTableView.tableHeaderView = containerView;
}

- (void)addFilterCollectionViewControllerWithSize:(CGSize)cellSize toContainerView:(UIView *)containerView
{
  AssertTrueOrReturn(containerView);
  
  self.filterCollectionViewController = [self filterCollectionViewControllerWithYOffset:kPlayerInfoViewHeight size:cellSize];
  [self addChildViewController:self.filterCollectionViewController];
  [containerView addSubview:self.filterCollectionViewController.collectionView];
  [self.filterCollectionViewController didMoveToParentViewController:self];
}

- (EditProfileFilterCollectionViewController *)filterCollectionViewControllerWithYOffset:(CGFloat)yOffset size:(CGSize)size
{
  EditProfileFilterCollectionViewController *collectionViewController = [[EditProfileFilterCollectionViewController alloc] init];
  
  collectionViewController.tutorialsTabSelectedBlock = ^() {
    NSLog(@"<DEBUG> Tutorials tab selected");
  };
  collectionViewController.likedTabSelectedBlock = ^() {
    NSLog(@"<DEBUG> Liked tab selected");
  };
  collectionViewController.followingTabSelectedBlock = ^() {
    NSLog(@"<DEBUG> Following tab selected");
  };
  collectionViewController.followersTabSelectedBlock = ^() {
    NSLog(@"<DEBUG> Followers tab selected");
  };
  
  UICollectionView *collectionView = collectionViewController.collectionView;
  collectionView.frame = CGRectMake(0, yOffset, size.width, size.height);
  collectionView.backgroundColor = [ColorsHelper tutorialsUnselectedFilterButtonColor];
  
  return collectionViewController;
}

#pragma mark - Tutorials Table View Delegate

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows
{
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
  [self updateFilterViewTutorialsCount];
}

- (void)updateFilterViewTutorialsCount
{
  self.filterCollectionViewController.tutorialsCount = [self.tutorialsTableDataSource numberOfRowsForSectionNamed:@"Published"];
}

#pragma mark - Other methods 

- (void)presentEditProfileViewController
{
  EditProfileViewController *editProfileViewController = [[EditProfileViewController alloc] initWithUser:self.user];

  defineWeakSelf();
  editProfileViewController.didUpdateUserProfileBlock = ^() {
    [weakSelf forceFetchUser];
    weakSelf.playerInfoView.user = self.user;
  };
  UINavigationController *navigationController = [ApplicationViewHierarchyHelper navigationControllerWithViewController:editProfileViewController];
  [self presentViewController:navigationController animated:YES completion:nil];
}

@end
