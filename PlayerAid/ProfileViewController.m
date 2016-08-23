//
//  PlayerAid
//

@import KZAsserts;
@import BlocksKit;
@import TWCommonLib;
@import MagicalRecord;
#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"
#import "ColorsHelper.h"
#import "ApplicationViewHierarchyHelper.h"
#import "TabBarBadgeHelper.h"
#import "EditProfileViewController.h"
#import "ProfileTabSwitcherViewController.h"
#import "FollowedUserTableViewCell.h"
#import "FollowedUserTableViewDelegate.h"
#import "TutorialDetailsHelper.h"
#import "CreateTutorialViewController.h"
#import "DebugSettings.h"
#import "NoTutorialsView.h"

static const NSUInteger kFilterCollectionViewHeight = 54.0f;
static const NSUInteger kPlayerInfoViewHeight = 310;
static const NSUInteger kDistanceBetweenPlayerInfoAndFirstTutorial = 18;

@interface ProfileViewController () <TutorialsTableViewDelegate>
@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *ownTutorialsTableDataSource;
@property (strong, nonatomic) TutorialsTableDataSource *likedTutorialsTableDataSource;
@property (strong, nonatomic) TWArrayTableViewDataSource *followingDataSource;
@property (strong, nonatomic) TWArrayTableViewDataSource *followersDataSource;
@property (strong, nonatomic) FollowedUserTableViewDelegate *followingTableViewDelegate;
@property (strong, nonatomic) FollowedUserTableViewDelegate *followersTableViewDelegate;
@property (weak, nonatomic) IBOutlet NoTutorialsView *noTutorialsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noTutorialsOverlayTopConstraint;
@property (strong, nonatomic) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (strong, nonatomic) ProfileTabSwitcherViewController *tabSwitcherViewController;
@property (weak, nonatomic) Tutorial *lastSelectedTutorial;
@end


@implementation ProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self tw_setNavbarDoesNotCoverTheView];  
  [self setupUserIfNotNil];
  [self setupTableViewUserFollowedCells];
  [self setupOwnTutorialsTableDataSource];
  [self setupTableHeaderView];
  [self setupPlayerInfoView];
  [self setupOwnTutorialsTableViewOverlay];
  [self setupKeyValueObservers];
  
  if (DEBUG_MODE_PUSH_EDIT_PROFILE) {
    [self presentEditProfileViewController];
  }
}

- (void)dealloc {
  [self removeKeyValueObservers];
}

- (void)setupUserIfNotNil {
  if (!self.user) {
    [self forceFetchUser];
  }
  AssertTrueOrReturn(self.user);
}

- (void)forceFetchUser {
  self.user = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"loggedInUser == 1"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[TabBarBadgeHelper new] hideProfileTabBarItemBadge];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateTabSwitcherGuidesCount];

  [self updateNavigationBarVisibility];
}

- (void)updateNavigationBarVisibility {
  BOOL isOnlyViewControllerOnNavigationStack = (self.navigationController.viewControllers.count == 1);
  if (isOnlyViewControllerOnNavigationStack) {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  }
}

- (void)updateTabSwitcherGuidesCount {
  self.tabSwitcherViewController.tutorialsCount = self.publishedTutorialsCount;
  self.tabSwitcherViewController.likedTutorialsCount = self.user.likes.count;
  self.tabSwitcherViewController.followingCount = self.user.follows.count;
  self.tabSwitcherViewController.followersCount = self.user.isFollowedBy.count;
}

#pragma mark - View Layout

-(void)viewDidLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self updateTableOverlayTopConstraint];
}

#pragma mark - KVO

- (void)setupKeyValueObservers
{
  defineWeakSelf();
  [self bk_addObserverForKeyPath:@"user.tutorials" task:^(id target) {
    weakSelf.tabSwitcherViewController.tutorialsCount = weakSelf.publishedTutorialsCount;
  }];
  [self bk_addObserverForKeyPath:@"user.likes" task:^(id target) {
    weakSelf.tabSwitcherViewController.likedTutorialsCount = weakSelf.user.likes.count;
  }];
  [self bk_addObserverForKeyPath:@"user.follows" task:^(id target) {
    weakSelf.tabSwitcherViewController.followingCount = weakSelf.user.follows.count;
  }];
  [self bk_addObserverForKeyPath:@"user.isFollowedBy" task:^(id target) {
    weakSelf.tabSwitcherViewController.followersCount = weakSelf.user.isFollowedBy.count;
  }];
}

- (void)removeKeyValueObservers {
  [self bk_removeAllBlockObservers];
}

#pragma mark - TableView overlays

- (void)setupOwnTutorialsTableViewOverlay
{
  [self.noTutorialsView setText:@"No guides made" imageNamed:@"emptystate-tutorial-ic"];
  [self setupEmptyTableViewBehaviourWithOverlay:self.noTutorialsView dataSource:self.ownTutorialsTableDataSource];
}

- (void)setupLikedTutorialsTableViewOverlay
{
  [self.noTutorialsView setText:@"No liked guides" imageNamed:@"emptystate-liked-ic"];
  [self setupEmptyTableViewBehaviourWithOverlay:self.noTutorialsView dataSource:self.likedTutorialsTableDataSource];
}

- (void)setupNotFollowingAnyoneTableViewOverlay
{
  [self.noTutorialsView setText:@"Not following anyone yet" imageNamed:@"emptystate-followers-ic"];
  [self setupEmptyTableViewBehaviourWithOverlay:self.noTutorialsView dataSource:self.followingDataSource];
}

- (void)setupNoFollowersTableViewOverlay
{
  [self.noTutorialsView setText:@"No followers yet" imageNamed:@"emptystate-followers-ic"];
  [self setupEmptyTableViewBehaviourWithOverlay:self.noTutorialsView dataSource:self.followersDataSource];
}

- (void)setupEmptyTableViewBehaviourWithOverlay:(UIView *)overlay dataSource:(id<TWObjectCountProtocol>)dataSource
{
  AssertTrueOrReturn(overlay);
  AssertTrueOrReturn(dataSource);
  self.noTutorialsView.hidden = YES;
  
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.tutorialTableView dataSource:dataSource overlayView:overlay allowScrollingWhenNoCells:NO];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
  [self updateTableOverlayTopConstraint];
}

#pragma mark - Overlay position

- (void)updateTableOverlayTopConstraint
{
  CGFloat playerInfoHeight = self.playerInfoView.frame.size.height;
  CGFloat tableHeight = self.tutorialTableView.frame.size.height;
  CGFloat noTutorialsOverlayHeight = self.noTutorialsView.frame.size.height;
  CGFloat topConstant = playerInfoHeight + (tableHeight - playerInfoHeight - noTutorialsOverlayHeight) * 0.5;
  topConstant = round(topConstant);
  
  self.noTutorialsOverlayTopConstraint.constant = topConstant;
}

#pragma mark - DataSources setup

- (void)setupTableViewUserFollowedCells {
  UINib *nib = [UINib nibWithNibName:@"FollowedUser" bundle:nil];
  [self.tutorialTableView registerNib:nib forCellReuseIdentifier:@"UserCellIdentifier"];
}

- (void)setupOwnTutorialsTableDataSource {
  self.ownTutorialsTableDataSource = [self createTutorialsTableDataSourceNoPredicate];
  self.ownTutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"reportedByUser == 0 AND createdBy = %@", self.user];
  self.ownTutorialsTableDataSource.groupBy = @"state";
  self.ownTutorialsTableDataSource.showSectionHeaders = NO;
  self.ownTutorialsTableDataSource.swipeToDeleteEnabled = YES;
}

- (void)setupFollowingTableViewDelegate {
  self.followingTableViewDelegate = [self followedUserTableViewDelegateForDataSource:self.followingDataSource];
}

- (void)setupFollowersTableViewDelegate {
  self.followersTableViewDelegate = [self followedUserTableViewDelegateForDataSource:self.followersDataSource];
}

- (void)setupLikedTutorialsTableDataSource {
  self.likedTutorialsTableDataSource = [self createTutorialsTableDataSourceNoPredicate];
  self.likedTutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"reportedByUser == 0 AND %@ IN likedBy", self.user]; // TODO: would be much faster other way round - just displaying user.likes...
}

- (void)setupFollowingUsersTableDataSource {
  self.followingDataSource = [self createUserCellDataSourceWithObjects:self.user.follows.allObjects];
}

- (void)setupFollowersTableDataSource {
  self.followersDataSource = [self createUserCellDataSourceWithObjects:self.user.isFollowedBy.allObjects];
}

- (TWArrayTableViewDataSource *)createUserCellDataSourceWithObjects:(NSArray *)objects
{
  AssertTrueOrReturnNil(objects);
  TWArrayTableViewDataSource *dataSource = [[TWArrayTableViewDataSource alloc] initWithArray:objects attachToTableView:self.tutorialTableView cellDequeueIdentifier:@"UserCellIdentifier"];
  
  dataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[FollowedUserTableViewCell class]]);
    FollowedUserTableViewCell *userCell = (FollowedUserTableViewCell *)cell;
    
    AssertTrueOrReturn(indexPath.row < objects.count);
    id object = objects[indexPath.row];
    
    AssertTrueOrReturn([object isKindOfClass:[User class]]);
    [userCell configureWithUser:(User *)object];
  };
  return dataSource;
}

- (TutorialsTableDataSource *)createTutorialsTableDataSourceNoPredicate
{
  TutorialsTableDataSource *dataSource = [[TutorialsTableDataSource alloc] initAttachingToTableView:self.tutorialTableView];
  dataSource.tutorialTableViewDelegate = self;
  dataSource.userAvatarOrNameSelectedBlock = [ApplicationViewHierarchyHelper pushProfileVCFromNavigationController:self.navigationController allowPushingLoggedInUser:NO];
  return dataSource;
}

- (FollowedUserTableViewDelegate *)followedUserTableViewDelegateForDataSource:(TWArrayTableViewDataSource *)dataSource
{
  AssertTrueOrReturnNil(dataSource);
  
  defineWeakSelf();
  __weak typeof(id) weakDataSource = dataSource;
  FollowedUserTableViewDelegate *delegate = [FollowedUserTableViewDelegate new];
  delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    void (^profilePushingBlock)(User *) = [ApplicationViewHierarchyHelper pushProfileVCFromNavigationController:weakSelf.navigationController allowPushingLoggedInUser:NO];
    AssertTrueOrReturn(profilePushingBlock);
    
    User *user = [weakDataSource objectAtIndexPath:indexPath];
    AssertTrueOrReturn(user);
    CallBlock(profilePushingBlock, user);
    [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
  };
  return delegate;
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
  
  [self addTabSwitcherViewControllerWithSize:CGSizeMake(windowWidth, kFilterCollectionViewHeight) toContainerView:containerView];
  
  self.tutorialTableView.tableHeaderView = containerView;
}

- (void)addTabSwitcherViewControllerWithSize:(CGSize)cellSize toContainerView:(UIView *)containerView
{
  AssertTrueOrReturn(containerView);
  
  self.tabSwitcherViewController = [self tabSwitcherViewControllerWithYOffset:kPlayerInfoViewHeight size:cellSize];
  [self addChildViewController:self.tabSwitcherViewController];
  [containerView addSubview:self.tabSwitcherViewController.collectionView];
  [self.tabSwitcherViewController didMoveToParentViewController:self];
}

- (ProfileTabSwitcherViewController *)tabSwitcherViewControllerWithYOffset:(CGFloat)yOffset size:(CGSize)size
{
  ProfileTabSwitcherViewController *collectionViewController = [[ProfileTabSwitcherViewController alloc] init];
  defineWeakSelf();
  
  collectionViewController.tutorialsTabSelectedBlock = ^() {
    [weakSelf setupOwnTutorialsTableDataSource];
    [weakSelf setupOwnTutorialsTableViewOverlay];
    [weakSelf reloadTableView];
    weakSelf.tabSwitcherViewController.tutorialsCount = weakSelf.publishedTutorialsCount;
  };
  collectionViewController.likedTabSelectedBlock = ^() {
    [weakSelf setupLikedTutorialsTableDataSource];
    [weakSelf setupLikedTutorialsTableViewOverlay];
    [weakSelf reloadTableView];
    weakSelf.tabSwitcherViewController.likedTutorialsCount = weakSelf.likedTutorialsTableDataSource.objectCount;
  };
  collectionViewController.followingTabSelectedBlock = ^() {
    [weakSelf setupFollowingUsersTableDataSource];
    [weakSelf setupFollowingTableViewDelegate];
    weakSelf.tutorialTableView.delegate = weakSelf.followingTableViewDelegate;
    [weakSelf reloadTableView];
    [weakSelf setupNotFollowingAnyoneTableViewOverlay];
    weakSelf.tabSwitcherViewController.followingCount = weakSelf.followingDataSource.objectCount;
  };
  collectionViewController.followersTabSelectedBlock = ^() {
    [weakSelf setupFollowersTableDataSource];
    [weakSelf setupFollowersTableViewDelegate];
    weakSelf.tutorialTableView.delegate = weakSelf.followersTableViewDelegate;
    [weakSelf reloadTableView];
    [weakSelf setupNoFollowersTableViewOverlay];
    weakSelf.tabSwitcherViewController.followersCount = weakSelf.followersDataSource.objectCount;
  };
  
  UICollectionView *collectionView = collectionViewController.collectionView;
  collectionView.frame = CGRectMake(0, yOffset, size.width, size.height);
  collectionView.backgroundColor = [ColorsHelper tutorialsUnselectedFilterButtonColor];
  
  return collectionViewController;
}

#pragma mark - Tutorials Table View Delegate

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows {
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
  [self updateTabSwitcherGuidesCount];
}

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial {
  self.lastSelectedTutorial = tutorial;
  
  if (tutorial.isDraft) {
    [ApplicationViewHierarchyHelper presentCreateTutorialViewControllerForTutorial:tutorial isEditingDraft:YES];
  }
  else {
    [[TutorialDetailsHelper new] performTutorialDetailsSegueFromViewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  }
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [[TutorialDetailsHelper new] prepareForTutorialDetailsSegue:segue pushingTutorial:self.lastSelectedTutorial];
}

#pragma mark - Private

- (void)presentEditProfileViewController {
    defineWeakSelf();
    [ApplicationViewHierarchyHelper presentEditProfileViewControllerFromViewController:self withUser:self.user didUpdateProfileBlock:^{
        [weakSelf forceFetchUser];
        weakSelf.playerInfoView.user = self.user;
    }];
}

- (void)reloadTableView {
  [self.tutorialTableView reloadData];
}

- (NSInteger)publishedTutorialsCount {
  return [self.ownTutorialsTableDataSource numberOfRowsForSectionNamed:@"Published"];
}

@end
