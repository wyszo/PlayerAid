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
#import "FollowedUserTableViewCell.h"
#import "FollowedUserTableViewDelegate.h"
#import "FollowingButtonDecorator.h"
#import "TutorialDetailsHelper.h"


static const NSUInteger kFilterCollectionViewHeight = 54.0f;
static const NSUInteger kPlayerInfoViewHeight = 310;
static const NSUInteger kDistanceBetweenPlayerInfoAndFirstTutorial = 18;


@interface ProfileViewController () <TutorialsTableViewDelegate>

@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (strong, nonatomic) TWArrayTableViewDataSource *followingDataSource;
@property (strong, nonatomic) TWArrayTableViewDataSource *followersDataSource;
@property (strong, nonatomic) FollowedUserTableViewDelegate *followedUserTableViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLikedTutorialsLabel;
@property (strong, nonatomic) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (strong, nonatomic) EditProfileFilterCollectionViewController *filterCollectionViewController;
@property (weak, nonatomic) Tutorial *lastSelectedTutorial;

@end


@implementation ProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.followedUserTableViewDelegate = [FollowedUserTableViewDelegate new];

  [self tw_setNavbarDoesNotCoverTheView];  
  [self setupUserIfNotNil];
  [self setupTableViewUserFollowedCells];
  [self setupTutorialsTableDataSource];
  [self setupTableHeaderView];
  [self setupPlayerInfoView];
  
  self.noTutorialsLabel.text = @"You haven't created any tutorials yet!";
  [self setupUserTutorialsTableViewOverlay];
  
  if (DEBUG_MODE_PUSH_EDIT_PROFILE) {
    [self presentEditProfileViewController];
  }
}

- (void)setupUserTutorialsTableViewOverlay
{
  [self setupEmptyTableViewBehaviourWithOverlay:self.noTutorialsLabel];
}

- (void)setupLikedTutorialsTableViewOverlay
{
  [self setupEmptyTableViewBehaviourWithOverlay:self.noLikedTutorialsLabel];
}

- (void)setupEmptyTableViewBehaviourWithOverlay:(UIView *)overlay
{
  AssertTrueOrReturn(overlay);
  
  [self hideAllNoItemsOverlays];
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.tutorialTableView dataSource:self.tutorialsTableDataSource overlayView:overlay allowScrollingWhenNoCells:NO];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

- (void)hideAllNoItemsOverlays
{
  self.noTutorialsLabel.hidden = YES;
  self.noLikedTutorialsLabel.hidden = YES;
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
  dataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:self allowPushingLoggedInUser:NO];
  return dataSource;
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
    [weakSelf hideAllNoItemsOverlays];
    weakSelf.tutorialTableView.delegate = self.followedUserTableViewDelegate;
    [weakSelf setupFollowingUsersTableDataSource];
    [weakSelf reloadTableView];
    weakSelf.filterCollectionViewController.followingCount = weakSelf.followingDataSource.objectCount;
  };
  collectionViewController.followersTabSelectedBlock = ^() {
    [weakSelf hideAllNoItemsOverlays];
    weakSelf.tutorialTableView.delegate = self.followedUserTableViewDelegate;
    [weakSelf setupFollowersTableDataSource];
    [weakSelf reloadTableView];
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

- (void)updateFilterViewTutorialsCount
{
  self.filterCollectionViewController.tutorialsCount = [self.tutorialsTableDataSource numberOfRowsForSectionNamed:@"Published"];
}

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  self.lastSelectedTutorial = tutorial;
  
  if (tutorial.isDraft) {
    // TODO: push CreateTutorial flow filled with draft tutorial's data
    NOT_IMPLEMENTED_YET_RETURN
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
