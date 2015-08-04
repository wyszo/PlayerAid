//
//  PlayerAid
//

#import <BlocksKit/BlocksKit.h>
#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"
#import "ColorsHelper.h"
#import "ApplicationViewHierarchyHelper.h"
#import "TabBarBadgeHelper.h"
#import "EditProfileViewController.h"
#import "EditProfileFilterCollectionViewController.h"
#import "FollowedUserTableViewCell.h"
#import "FollowedUserTableViewDelegate.h"
#import "FollowingButtonDecorator.h"
#import "TutorialDetailsHelper.h"
#import "CreateTutorialViewController.h"


static const NSUInteger kFilterCollectionViewHeight = 54.0f;
static const NSUInteger kPlayerInfoViewHeight = 310;
static const NSUInteger kDistanceBetweenPlayerInfoAndFirstTutorial = 18;


@interface ProfileViewController () <TutorialsTableViewDelegate>

@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (strong, nonatomic) TWArrayTableViewDataSource *followingDataSource;
@property (strong, nonatomic) TWArrayTableViewDataSource *followersDataSource;
@property (strong, nonatomic) FollowedUserTableViewDelegate *followingTableViewDelegate;
@property (strong, nonatomic) FollowedUserTableViewDelegate *followersTableViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (strong, nonatomic) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (strong, nonatomic) EditProfileFilterCollectionViewController *filterCollectionViewController;
@property (weak, nonatomic) Tutorial *lastSelectedTutorial;

@end


@implementation ProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self tw_setNavbarDoesNotCoverTheView];  
  [self setupUserIfNotNil];
  [self setupTableViewUserFollowedCells];
  [self setupTutorialsTableDataSource];
  [self setupTableHeaderView];
  [self setupPlayerInfoView];
  [self setupUserTutorialsTableViewOverlay];
  [self setupKeyValueObservers];
    
  if (DEBUG_MODE_PUSH_EDIT_PROFILE) {
    [self presentEditProfileViewController];
  }
}

- (void)dealloc
{
  [self removeKeyValueObservers];
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

-(void)viewWillDisappear:(BOOL)animated
{
  if (![self isPartOfNavigationControllerStrack]) {
    [self backButtonPressed];
  }
  [super viewWillDisappear:animated];
}

- (BOOL)isPartOfNavigationControllerStrack
{
  return ([self.navigationController.viewControllers indexOfObject:self] != NSNotFound);
}

- (void)updateFilterViewTutorialsCount
{
  self.filterCollectionViewController.tutorialsCount = [self.tutorialsTableDataSource numberOfRowsForSectionNamed:@"Published"];
  self.filterCollectionViewController.likedTutorialsCount = self.user.likes.count;
  self.filterCollectionViewController.followingCount = self.user.follows.count;
  self.filterCollectionViewController.followersCount = self.user.isFollowedBy.count;
}

#pragma mark - KVO

- (void)setupKeyValueObservers
{
  [self bk_addObserverForKeyPath:@"user.likes" task:^(id target) {
    self.filterCollectionViewController.likedTutorialsCount = self.user.likes.count;
  }];
  [self bk_addObserverForKeyPath:@"user.tutorials" task:^(id target) {
    self.filterCollectionViewController.tutorialsCount = self.user.createdTutorial.count;
  }];
  [self bk_addObserverForKeyPath:@"user.follows" task:^(id target) {
    self.filterCollectionViewController.followingCount = self.user.follows.count;
  }];
  [self bk_addObserverForKeyPath:@"user.isFollowedBy" task:^(id target) {
    self.filterCollectionViewController.followersCount = self.user.isFollowedBy.count;
  }];
}

- (void)removeKeyValueObservers
{
  [self bk_removeAllBlockObservers];
}

#pragma mark - TableView overlays

- (void)setupUserTutorialsTableViewOverlay
{
  self.noItemsLabel.text = @"You haven't created any tutorials yet!";
  [self setupEmptyTableViewBehaviourWithOverlay:self.noItemsLabel dataSource:self.tutorialsTableDataSource];
}

- (void)setupLikedTutorialsTableViewOverlay
{
  self.noItemsLabel.text = @"No liked tutorials";
  [self setupEmptyTableViewBehaviourWithOverlay:self.noItemsLabel dataSource:self.tutorialsTableDataSource];
}

- (void)setupNotFollowingAnyoneTableViewOverlay
{
  self.noItemsLabel.text = @"Not following anyone";
  [self setupEmptyTableViewBehaviourWithOverlay:self.noItemsLabel dataSource:self.followingDataSource];
}

- (void)setupNoFollowersTableViewOverlay
{
  self.noItemsLabel.text = @"No followers";
  [self setupEmptyTableViewBehaviourWithOverlay:self.noItemsLabel dataSource:self.followersDataSource];
}

- (void)setupEmptyTableViewBehaviourWithOverlay:(UIView *)overlay dataSource:(id<TWObjectCountProtocol>)dataSource
{
  AssertTrueOrReturn(overlay);
  AssertTrueOrReturn(dataSource);
  self.noItemsLabel.hidden = YES;
  
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.tutorialTableView dataSource:dataSource overlayView:overlay allowScrollingWhenNoCells:NO];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - DataSources setup

- (void)setupTableViewUserFollowedCells
{
  UINib *nib = [UINib nibWithNibName:@"FollowedUser" bundle:nil];
  [self.tutorialTableView registerNib:nib forCellReuseIdentifier:@"UserCellIdentifier"];
}

- (void)setupTutorialsTableDataSource
{
  self.tutorialsTableDataSource = [self createTutorialsTableDataSourceNoPredicate];
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"createdBy = %@ AND state != %@", self.user, kTutorialStateUnsaved];
  self.tutorialsTableDataSource.groupBy = @"state";
  self.tutorialsTableDataSource.showSectionHeaders = YES;
  self.tutorialsTableDataSource.swipeToDeleteEnabled = YES;
}

- (void)setupFollowingTableViewDelegate
{
  self.followingTableViewDelegate = [self followedUserTableViewDelegateForDataSource:self.followingDataSource];
}

- (void)setupFollowersTableViewDelegate
{
  self.followersTableViewDelegate = [self followedUserTableViewDelegateForDataSource:self.followersDataSource];
}

- (void)setupLikedTutorialsTableDataSource
{
  self.tutorialsTableDataSource = [self createTutorialsTableDataSourceNoPredicate];
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"%@ IN likedBy", self.user]; // TODO: would be much faster other way round - just displaying user.likes...
}

- (void)setupFollowingUsersTableDataSource
{
  self.followingDataSource = [self createUserCellDataSourceWithObjects:self.user.follows.allObjects];
}

- (void)setupFollowersTableDataSource
{
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
  dataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:self backButtonActionBlock:nil allowPushingLoggedInUser:NO];
  return dataSource;
}

- (FollowedUserTableViewDelegate *)followedUserTableViewDelegateForDataSource:(TWArrayTableViewDataSource *)dataSource
{
  AssertTrueOrReturnNil(dataSource);
  
  defineWeakSelf();
  __weak typeof(id) weakDataSource = dataSource;
  FollowedUserTableViewDelegate *delegate = [FollowedUserTableViewDelegate new];
  delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    void (^profilePushingBlock)(User *) = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:weakSelf backButtonActionBlock:^{
      [weakSelf.navigationController setNavigationBarHidden:YES animated:YES];
    } allowPushingLoggedInUser:NO];
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
  defineWeakSelf();
  
  collectionViewController.tutorialsTabSelectedBlock = ^() {
    [weakSelf setupTutorialsTableDataSource];
    [weakSelf setupUserTutorialsTableViewOverlay];
    [weakSelf reloadTableView];
  };
  collectionViewController.likedTabSelectedBlock = ^() {
    [weakSelf setupLikedTutorialsTableDataSource];
    [weakSelf setupLikedTutorialsTableViewOverlay];
    [weakSelf reloadTableView];
    weakSelf.filterCollectionViewController.likedTutorialsCount = weakSelf.tutorialsTableDataSource.objectCount;
  };
  collectionViewController.followingTabSelectedBlock = ^() {
    [weakSelf setupFollowingUsersTableDataSource];
    [weakSelf setupFollowingTableViewDelegate];
    weakSelf.tutorialTableView.delegate = self.followingTableViewDelegate;
    [weakSelf reloadTableView];
    [weakSelf setupNotFollowingAnyoneTableViewOverlay];
    weakSelf.filterCollectionViewController.followingCount = weakSelf.followingDataSource.objectCount;
  };
  collectionViewController.followersTabSelectedBlock = ^() {
    [weakSelf setupFollowersTableDataSource];
    [weakSelf setupFollowersTableViewDelegate];
    weakSelf.tutorialTableView.delegate = self.followersTableViewDelegate;
    [weakSelf reloadTableView];
    [weakSelf setupNoFollowersTableViewOverlay];
    weakSelf.filterCollectionViewController.followersCount = weakSelf.followersDataSource.objectCount;
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

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  self.lastSelectedTutorial = tutorial;
  
  if (tutorial.isDraft) {
    UIViewController *viewController = [ApplicationViewHierarchyHelper presentModalCreateTutorialViewController];
    AssertTrueOrReturn([viewController isKindOfClass:[CreateTutorialViewController class]]);
    CreateTutorialViewController *createTutorialViewController = (CreateTutorialViewController *)viewController;
    createTutorialViewController.tutorialToDisplay = tutorial;
    createTutorialViewController.isEditingDraft = YES;
  }
  else {
    [[TutorialDetailsHelper new] performTutorialDetailsSegueFromViewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  }
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  defineWeakSelf();
  [[TutorialDetailsHelper new] prepareForTutorialDetailsSegue:segue pushingTutorial:self.lastSelectedTutorial deallocBlock:^{
    [weakSelf.navigationController setNavigationBarHidden:YES animated:YES];
  }];
}

#pragma mark - Actions 

- (void)backButtonPressed {
  CallBlock(self.backButtonAction);
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

- (void)reloadTableView
{
  [self.tutorialTableView reloadData];
}

@end
