//
//  PlayerAid
//

#import "EditProfileFilterCollectionViewController.h"
#import "PlayerInfoCollectionViewCell.h"
#import "ColorsHelper.h"


static const CGFloat kCellWidth = 72.0f;

static const NSInteger kTutorialsCellIndex = 0;
static const NSInteger kLikedTutorialsCellIndex = 1;
static const NSInteger kFollowingUsersCellIndex = 2;
static const NSInteger kFollowersCellIndex = 3;


@interface EditProfileFilterCollectionViewController ()

@property (strong, nonatomic) NSArray *cellLabels;

@end


@implementation EditProfileFilterCollectionViewController

#pragma mark - View Lifecycle

- (instancetype)init
{
  self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.collectionView.dataSource = nil;
  self.collectionView.delegate = nil;
  self.cellLabels = @[ @"Tutorials", @"Liked", @"Following", @"Followers" ];
  
  [self setupCollectionView];
}

- (void)setupCollectionView
{
  [self.collectionView registerNib:[PlayerInfoCollectionViewCell nib] forCellWithReuseIdentifier:@"Cell"];
  
  [self setupCollectionViewDelegate];
  [self setupCollectionViewDataSource];
}

- (id<UICollectionViewDelegate>)setupCollectionViewDelegate
{
  CGFloat collectionViewHeight = self.collectionView.frame.size.height;
  CGSize cellSize = CGSizeMake(kCellWidth, collectionViewHeight);
  
  TWSimpleCollectionViewFlowLayoutDelegate *delegate = [[TWSimpleCollectionViewFlowLayoutDelegate alloc] initWithCellSize:cellSize collectionViewSize:self.collectionView.frame.size attachingToCollectionView:self.collectionView];
  delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    
    AssertTrueOrReturn(self.tutorialsTabSelectedBlock);
    AssertTrueOrReturn(self.likedTabSelectedBlock);
    AssertTrueOrReturn(self.followingTabSelectedBlock);
    AssertTrueOrReturn(self.followersTabSelectedBlock);
    
    NSArray *callbacks = @[ self.tutorialsTabSelectedBlock, self.likedTabSelectedBlock, self.followingTabSelectedBlock, self.followersTabSelectedBlock ];
    
    AssertTrueOrReturn(indexPath.row < callbacks.count);
    VoidBlock callback = callbacks[indexPath.row];
    CallBlock(callback);
  };
  return delegate;
}

- (void)setupCollectionViewDataSource
{
  TWSimpleCollectionViewDataSource *dataSource = [[TWSimpleCollectionViewDataSource alloc] initAttachingToCollectionView:self.collectionView];
  dataSource.numberOfItems = self.cellLabels.count;
  
  dataSource.cellConfigurationBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[PlayerInfoCollectionViewCell class]]);
    PlayerInfoCollectionViewCell *collectionViewCell = (PlayerInfoCollectionViewCell *)cell;
    collectionViewCell.selectionBackgroundColor = [ColorsHelper tutorialsSelectedFilterButtonColor];
    
    AssertTrueOrReturn(indexPath.row < self.cellLabels.count);
    NSString *labelString = self.cellLabels[indexPath.row];
    collectionViewCell.bottomLabel.text = labelString;
  };
}

#pragma mark - ViewController Containment

- (void)didMoveToParentViewController:(UIViewController *)parent
{
  [super didMoveToParentViewController:parent];
  
  self.collectionView.delegate = nil;
  [self setupCollectionViewDelegate];
  [self selectTutorialCell];
}

#pragma mark - Updating counts

- (void)setTutorialsCount:(NSInteger)tutorialsCount
{
  _tutorialsCount = tutorialsCount;
  [self updateTutorialsCountLabels];
}

- (void)updateTutorialsCountLabels
{
  [self setCount:self.tutorialsCount inPlayerInfoCollectionViewCell:self.tutorialsCell];
  self.tutorialsCell.bottomLabel.text = (self.tutorialsCount == 1 ? @"Tutorial" : @"Tutorials");;
}

- (void)setLikedTutorialsCount:(NSInteger)likedTutorialsCount
{
  _likedTutorialsCount = likedTutorialsCount;
  [self setCount:likedTutorialsCount inPlayerInfoCollectionViewCell:self.likedCell];
}

- (void)setFollowingCount:(NSInteger)followingCount
{
  _followingCount = followingCount;
  [self setCount:followingCount inPlayerInfoCollectionViewCell:self.followingUsersCell];
}

- (void)setFollowersCount:(NSInteger)followersCount
{
  _followersCount = followersCount;
  [self setCount:followersCount inPlayerInfoCollectionViewCell:self.followersCell];
}

- (void)setCount:(NSInteger)count inPlayerInfoCollectionViewCell:(PlayerInfoCollectionViewCell *)cell
{
  AssertTrueOrReturn(cell);
  cell.topLabel.text = [@(count) stringValue];
}

#pragma mark - Auxiliary methods

- (void)selectTutorialCell
{
  [self.collectionView selectItemAtIndexPath:self.tutorialsCellIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (PlayerInfoCollectionViewCell *)cellForRow:(NSInteger)row
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  
  PlayerInfoCollectionViewCell *cell = (PlayerInfoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
  AssertTrueOrReturnNil(cell && @"collection view not visible");
  return cell;
}

- (NSIndexPath *)tutorialsCellIndexPath
{
  return [NSIndexPath indexPathForRow:kTutorialsCellIndex inSection:0];
}

#pragma mark - Cells

- (PlayerInfoCollectionViewCell *)tutorialsCell
{
  return [self cellForRow:kTutorialsCellIndex];
}

- (PlayerInfoCollectionViewCell *)likedCell
{
  return [self cellForRow:kLikedTutorialsCellIndex];
}

- (PlayerInfoCollectionViewCell *)followingUsersCell
{
  return [self cellForRow:kFollowingUsersCellIndex];
}

- (PlayerInfoCollectionViewCell *)followersCell
{
  return [self cellForRow:kFollowersCellIndex];
}

@end
