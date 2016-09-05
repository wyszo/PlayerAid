@import KZAsserts;
@import TWCommonLib;
#import "ProfileTabSwitcherViewController.h"
#import "PlayerInfoCollectionViewCell.h"
#import "ColorsHelper.h"
#import "PlayerAid-Swift.h"

static const CGFloat kCellWidth = 72.0f;

// TODO: change this to enumeration
static const NSInteger kTutorialsCellIndex = 0;
static const NSInteger kLikedTutorialsCellIndex = 1;
static const NSInteger kFollowingUsersCellIndex = 2;
static const NSInteger kFollowersCellIndex = 3;

static const NSInteger kCollectionViewNumberOfCells = 4;
static const CGFloat kTabSelectionViewHeight = 6.0;
static const CGFloat kTabSelectionViewMargin = 8.0;


@interface ProfileTabSwitcherViewController ()
@property (strong, nonatomic) NSArray *cellLabels;

@property (assign, nonatomic) NSInteger selectedCellIndex;
@property (strong, nonatomic) FloatingSelectionOverlay *selectionOverlay;
@end


@implementation ProfileTabSwitcherViewController

#pragma mark - View Lifecycle

- (instancetype)init {
  self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.collectionView.dataSource = nil;
  self.collectionView.delegate = nil;
  self.cellLabels = @[ @"Tutorials", @"Liked", @"Following", @"Followers" ];
  [self setupCollectionView];
  
  self.selectionOverlay = [[FloatingSelectionOverlay alloc] initWithColor:[ColorsHelper tutorialsSelectedFilterButtonColor] superview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateSelectionOverlayAnimated:NO];
}

#pragma mark - CollectionView setup

- (void)setupCollectionView {
  [self.collectionView registerNib:[PlayerInfoCollectionViewCell nib] forCellWithReuseIdentifier:@"Cell"];
  
  [self setupCollectionViewDelegate];
  [self setupCollectionViewDataSource];
}

- (id<UICollectionViewDelegate>)setupCollectionViewDelegate {
  CGFloat collectionViewHeight = self.collectionView.frame.size.height;
  CGSize cellSize = CGSizeMake(kCellWidth, collectionViewHeight);
  
  TWSimpleCollectionViewFlowLayoutDelegate *delegate = [[TWSimpleCollectionViewFlowLayoutDelegate alloc] initWithCellSize:cellSize
                                                                                                       collectionViewSize:self.collectionView.frame.size
                                                                                                            numberOfCells:kCollectionViewNumberOfCells
                                                                                                attachingToCollectionView:self.collectionView];
  defineWeakSelf();
  delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    AssertTrueOrReturn(weakSelf.tutorialsTabSelectedBlock);
    AssertTrueOrReturn(weakSelf.likedTabSelectedBlock);
    AssertTrueOrReturn(weakSelf.followingTabSelectedBlock);
    AssertTrueOrReturn(weakSelf.followersTabSelectedBlock);
    
    NSArray *callbacks = @[ weakSelf.tutorialsTabSelectedBlock, weakSelf.likedTabSelectedBlock, weakSelf.followingTabSelectedBlock, weakSelf.followersTabSelectedBlock ];
    
    AssertTrueOrReturn(indexPath.row < callbacks.count);
    VoidBlock callback = callbacks[indexPath.row];
    CallBlock(callback);
    
    weakSelf.selectedCellIndex = indexPath.row;
    [weakSelf updateSelectionOverlayAnimated:YES];
  };
  return delegate;
}

- (void)setupCollectionViewDataSource {
  TWSimpleCollectionViewDataSource *dataSource = [[TWSimpleCollectionViewDataSource alloc] initAttachingToCollectionView:self.collectionView];
  dataSource.numberOfItems = [self numberOfItems];
  
  defineWeakSelf();
  dataSource.cellConfigurationBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[PlayerInfoCollectionViewCell class]]);
    PlayerInfoCollectionViewCell *collectionViewCell = (PlayerInfoCollectionViewCell *)cell;
    collectionViewCell.selectedTextColor = [ColorsHelper tutorialsSelectedFilterButtonTextColor];
    collectionViewCell.unselectedTextColor = [ColorsHelper tutorialsUnselectedFilterButtonTextColor];
    
    BOOL selected = (indexPath.row == 0);
    [collectionViewCell setSelected:selected];
    
    AssertTrueOrReturn(indexPath.row < weakSelf.cellLabels.count);
    NSString *labelString = weakSelf.cellLabels[indexPath.row];
    collectionViewCell.bottomLabel.text = labelString;
  };
}

- (NSInteger)numberOfItems {
    return self.cellLabels.count;
}

#pragma mark - Selection Overlay

- (void)updateSelectionOverlayAnimated:(BOOL)animated {
    CGRect frame = [self frameForSelectionOverlayForSelectedIndex:self.selectedCellIndex];
    [self.selectionOverlay setFrame:frame animated:animated];
}

- (CGRect)frameForSelectionOverlayForSelectedIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedCellIndex inSection:0];
    
    CGRect frame = [self.collectionView cellForItemAtIndexPath: indexPath].frame; // this only works for visible cells!
    AssertTrueOr(frame.size.width != 0, return CGRectZero;);
    
    // selection view height
    frame.origin.y = frame.size.height - kTabSelectionViewHeight;
    frame.size.height = kTabSelectionViewHeight;
    
    // margins
    frame.origin.x += kTabSelectionViewMargin;
    frame.size.width -= 2 * kTabSelectionViewMargin;
    
    return frame;
}

#pragma mark - ViewController Containment

- (void)didMoveToParentViewController:(UIViewController *)parent {
  [super didMoveToParentViewController:parent];
  
  self.collectionView.delegate = nil;
  [self setupCollectionViewDelegate];
  [self selectTutorialCell];
}

#pragma mark - Updating counts

- (void)setTutorialsCount:(NSInteger)tutorialsCount {
  _tutorialsCount = tutorialsCount;
  [self updateOwnGuidesCountLabel];
}

- (void)updateOwnGuidesCountLabel {
  [self setCount:self.tutorialsCount inPlayerInfoCollectionViewCell:self.tutorialsCell];
  self.tutorialsCell.bottomLabel.text = (self.tutorialsCount == 1 ? @"Guide" : @"Guides");;
}

- (void)setLikedTutorialsCount:(NSInteger)likedTutorialsCount {
  _likedTutorialsCount = likedTutorialsCount;
  [self setCount:likedTutorialsCount inPlayerInfoCollectionViewCell:self.likedCell];
}

- (void)setFollowingCount:(NSInteger)followingCount {
  _followingCount = followingCount;
  [self setCount:followingCount inPlayerInfoCollectionViewCell:self.followingUsersCell];
}

- (void)setFollowersCount:(NSInteger)followersCount {
  _followersCount = followersCount;
  [self setCount:followersCount inPlayerInfoCollectionViewCell:self.followersCell];
}

- (void)setCount:(NSInteger)count inPlayerInfoCollectionViewCell:(PlayerInfoCollectionViewCell *)cell {
  AssertTrueOrReturn(cell);
  cell.topLabel.text = [@(count) stringValue];
}

- (void)updateGuidesCountLabels {
    self.tutorialsCount = self.viewModel.guidesCount;
    self.likedTutorialsCount = self.viewModel.likedGuidesCount;
    self.followingCount = self.viewModel.followingCount;
    self.followersCount = self.viewModel.followersCount;
}

#pragma mark - Auxiliary methods

- (void)selectTutorialCell {
  [self.collectionView selectItemAtIndexPath:self.tutorialsCellIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (PlayerInfoCollectionViewCell *)cellForRow:(NSInteger)row {
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  
  PlayerInfoCollectionViewCell *cell = (PlayerInfoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
  AssertTrueOrReturnNil(cell && @"collection view not visible");
  return cell;
}

- (NSIndexPath *)tutorialsCellIndexPath {
  return [NSIndexPath indexPathForRow:kTutorialsCellIndex inSection:0];
}

#pragma mark - Cells

- (PlayerInfoCollectionViewCell *)tutorialsCell {
  return [self cellForRow:kTutorialsCellIndex];
}

- (PlayerInfoCollectionViewCell *)likedCell {
  return [self cellForRow:kLikedTutorialsCellIndex];
}

- (PlayerInfoCollectionViewCell *)followingUsersCell {
  return [self cellForRow:kFollowingUsersCellIndex];
}

- (PlayerInfoCollectionViewCell *)followersCell {
  return [self cellForRow:kFollowersCellIndex];
}

@end
