//
//  PlayerAid
//

#import "EditProfileFilterCollectionViewController.h"
#import "PlayerInfoCollectionViewCell.h"
#import "ColorsHelper.h"


static const CGFloat kCellWidth = 72.0f;
static const NSInteger kTutorialsItemIndex = 0;


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
  
  TWSimpleCollectionViewFlowLayoutDelegate *delegate = [[TWSimpleCollectionViewFlowLayoutDelegate alloc] initWithCellSize:cellSize attachingToCollectionView:self.collectionView];
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
  [self updateTutorialLabels];
}

- (void)updateTutorialLabels
{
  self.tutorialsCell.topLabel.text = [@(self.tutorialsCount) stringValue];
  self.tutorialsCell.bottomLabel.text = (self.tutorialsCount == 1 ? @"Tutorial" : @"Tutorials");;
}

#pragma mark - Auxiliary methods

- (void)selectTutorialCell
{
  [self.collectionView selectItemAtIndexPath:self.tutorialsCellIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (PlayerInfoCollectionViewCell *)tutorialsCell
{
  PlayerInfoCollectionViewCell *cell = (PlayerInfoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.tutorialsCellIndexPath];
  AssertTrueOrReturnNil(cell && @"collection view not visible");
  return cell;
}

- (NSIndexPath *)tutorialsCellIndexPath
{
  return [NSIndexPath indexPathForRow:kTutorialsItemIndex inSection:0];
}

@end
