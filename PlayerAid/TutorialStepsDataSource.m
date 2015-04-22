//
//  PlayerAid
//

#import "TutorialStepsDataSource.h"
#import "MediaPlayerHelper.h"
#import "AlertFactory.h"
#import "TutorialStep.h"
#import "Tutorial.h"
#import "CoreDataTableViewDataSource.h"
#import "TutorialStepTableViewCell.h"
#import "TableViewFetchedResultsControllerBinder+Private.h"
#import "UITableView+TableViewHelper.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";


@interface TutorialStepsDataSource () <UITableViewDelegate>

@property (nonatomic, strong) CoreDataTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) TableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) BOOL allowsEditing;

@end


@implementation TutorialStepsDataSource

#pragma mark - Initilization

// TODO: it's confusing that you don't set this class as a tableView dataSource and you just initialize it. Need to document it! 
- (instancetype)initWithTableView:(UITableView *)tableView tutorial:(Tutorial *)tutorial context:(NSManagedObjectContext *)context allowsEditing:(BOOL)allowsEditing
{
  AssertTrueOrReturnNil(tableView);
  AssertTrueOrReturnNil(tutorial);
  
  self = [super init];
  if (self) {
    _tableView = tableView;
    _tableView.delegate = self;
    _tutorial = tutorial;
    _context = context;
    _allowsEditing = allowsEditing;
    
    [self initFetchedResultsControllerBinder];
    [self initTableViewDataSource];
    
    UINib *tableViewCellNib =  [UINib nibWithNibName:kTutorialStepCellNibName bundle:[NSBundle bundleForClass:[self class]]];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kTutorialStepCellReuseIdentifier];
  }
  return self;
}

- (void)initFetchedResultsControllerBinder
{
  __weak typeof(self) weakSelf = self;
  _fetchedResultsControllerBinder = [[TableViewFetchedResultsControllerBinder alloc] initWithTableView:_tableView configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:(TutorialStepTableViewCell *)cell atIndexPath:indexPath];
  }];
}

- (void)initTableViewDataSource
{
  __weak typeof(self) weakSelf = self;
  
  _tableViewDataSource = [[CoreDataTableViewDataSource alloc] initWithCellreuseIdentifier:kTutorialStepCellReuseIdentifier configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[TutorialStepTableViewCell class]]);
    TutorialStepTableViewCell *tutorialStepCell = (TutorialStepTableViewCell *)cell;
    [weakSelf configureCell:tutorialStepCell atIndexPath:indexPath];
  }];
  
  [self setupTableViewDataSourceCellsEditing];
  
  _tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"belongsTo == %@", weakSelf.tutorial];
    return [TutorialStep MR_fetchAllSortedBy:@"order" ascending:YES withPredicate:predicate groupBy:nil delegate:weakSelf.fetchedResultsControllerBinder inContext:weakSelf.context];
  };
  _tableView.dataSource = _tableViewDataSource;
}

- (void)setupTableViewDataSourceCellsEditing
{
  if (!self.allowsEditing) {
    return;
  }
  
  [self setupTableViewDataSourceCellMoveRowBlock];
  [self setupTableViewDataSourceCellDeleteBlock];
}

- (void)setupTableViewDataSourceCellMoveRowBlock
{
  __weak typeof(self) weakSelf = self;
  // TODO: this block implementation should be made more generic and extracted from here to a separate class!!
  _tableViewDataSource.moveRowAtIndexPathToIndexPathBlock = ^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath) {
    if (fromIndexPath == toIndexPath) {
      return; // user didn't change the order after all
    }
    
    id objectFrom = [weakSelf.tableViewDataSource objectAtIndexPath:fromIndexPath];
    id objectTo = [weakSelf.tableViewDataSource objectAtIndexPath:toIndexPath];
    AssertTrueOrReturn([objectFrom isKindOfClass:[TutorialStep class]]);
    AssertTrueOrReturn([objectTo isKindOfClass:[TutorialStep class]]);
    
    TutorialStep *tutorialStepFrom = objectFrom;
    TutorialStep *tutorialStepTo = objectTo;
    
    AssertTrueOrReturn(tutorialStepFrom.belongsTo == tutorialStepTo.belongsTo);
    Tutorial *parentTutorial = tutorialStepFrom.belongsTo;
    AssertTrueOrReturn(parentTutorial);
    
    NSInteger fromIndex = [parentTutorial.consistsOf indexOfObject:tutorialStepFrom];
    NSInteger toIndex = [parentTutorial.consistsOf indexOfObject:tutorialStepTo];
    
    AssertTrueOrReturn(tutorialStepFrom.managedObjectContext == tutorialStepTo.managedObjectContext);
    AssertTrueOrReturn(tutorialStepFrom.managedObjectContext == weakSelf.context);
    
    // UI changed, just need to update the model without invoking NSFetchedResultsController methods. That's why we change the whole set instead of relaying on NSMutableOrderedSet methods replaceObjectsAtIndexes:
    NSMutableArray *allObjects = parentTutorial.consistsOf.array.mutableCopy;
    [allObjects replaceObjectAtIndex:fromIndex withObject:tutorialStepTo];
    [allObjects replaceObjectAtIndex:toIndex withObject:tutorialStepFrom];
    
    weakSelf.fetchedResultsControllerBinder.disabled = YES;
    
    NSNumber *toOrder = tutorialStepTo.order;
    tutorialStepTo.order = tutorialStepFrom.order;
    tutorialStepFrom.order = toOrder;
    
    AssertTrueOrReturn(![allObjects isEqualToArray:parentTutorial.consistsOf.array]);
    [parentTutorial setConsistsOf:[NSOrderedSet orderedSetWithArray:allObjects]];
    
    [weakSelf.context MR_saveOnlySelfAndWait];
    weakSelf.fetchedResultsControllerBinder.disabled = NO;
    
    [weakSelf.tableView reloadData]; // that doesn't really help, just hides the problem temporarily.. (the assertion above will be thrown sooner or later)..
  };
}

- (void)setupTableViewDataSourceCellDeleteBlock
{
  __weak typeof(self) weakSelf = self;
  _tableViewDataSource.deleteCellOnSwipeBlock = ^(NSIndexPath *indexPath) {
    NSString *message = @"Are you sure you want to delete this tutorial step? This action cannot be undone.";
    [AlertFactory showOKCancelAlertViewWithTitle:nil message:message okTitle:@"Yes, delete" okAction:^{
      TutorialStep *tutorialStep = [weakSelf.tableViewDataSource objectAtIndexPath:indexPath];
      AssertTrueOrReturn(weakSelf.context);
      [tutorialStep MR_deleteInContext:weakSelf.context];
      [weakSelf.context MR_saveOnlySelfAndWait];
      
      if (weakSelf.cellDeletionCompletionBlock) {
        weakSelf.cellDeletionCompletionBlock();
      }
    } cancelAction:^{
      [weakSelf.tableView reloadRowAtIndexPath:indexPath];
    }];
  };
}

- (void)configureCell:(TutorialStepTableViewCell *)tutorialStepCell atIndexPath:(NSIndexPath *)indexPath
{
  TutorialStep *tutorialStep = [self.tableViewDataSource objectAtIndexPath:indexPath];
  [tutorialStepCell configureWithTutorialStep:tutorialStep];
}

#pragma mark - Context 

- (NSManagedObjectContext *)context
{
  if (!_context) {
    return [NSManagedObjectContext MR_defaultContext];
  }
  return _context;
}

#pragma mark - Playing a video

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  TutorialStep *tutorialStep = [_tableViewDataSource objectAtIndexPath:indexPath];

  if (tutorialStep.videoPath) {
    NSURL *url = [NSURL URLWithString:tutorialStep.videoPath];
    [MediaPlayerHelper playVideoWithURL:url fromViewController:self.moviePlayerParentViewController];
  }
}

@end
