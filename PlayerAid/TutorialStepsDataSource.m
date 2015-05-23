//
//  PlayerAid
//

#import "TutorialStepsDataSource.h"
#import "AlertFactory.h"
#import "TutorialStep.h"
#import "Tutorial.h"
#import "CoreDataTableViewDataSource.h"
#import "TutorialStepTableViewCell.h"
#import "TableViewFetchedResultsControllerBinder.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";

static const CGFloat kTutorialStepCellHeight = 120;


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
    return [TutorialStep MR_fetchAllSortedBy:nil ascending:YES withPredicate:predicate groupBy:nil delegate:weakSelf.fetchedResultsControllerBinder inContext:weakSelf.context];
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
  _tableViewDataSource.moveRowAtIndexPathToIndexPathBlock = ^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath) {
    id objectFrom = [weakSelf.tableViewDataSource objectAtIndexPath:fromIndexPath];
    id objectTo = [weakSelf.tableViewDataSource objectAtIndexPath:toIndexPath];
    AssertTrueOrReturn([objectFrom isKindOfClass:[TutorialStep class]]);
    AssertTrueOrReturn([objectTo isKindOfClass:[TutorialStep class]]);
    
    TutorialStep *tutorialStepFrom = objectFrom;
    TutorialStep *tutorialStepTo = objectTo;
    
    Tutorial *parentTutorial = tutorialStepFrom.belongsTo;
    AssertTrueOrReturn(parentTutorial);
    AssertTrueOrReturn(parentTutorial == tutorialStepTo.belongsTo);
    
    NSInteger fromIndex = [parentTutorial.consistsOf indexOfObject:tutorialStepFrom];
    NSInteger toIndex = [parentTutorial.consistsOf indexOfObject:tutorialStepTo];
    
    TutorialStep *temporaryStep = [TutorialStep MR_createInContext:weakSelf.context];
    
    [parentTutorial replaceObjectInConsistsOfAtIndex:fromIndex withObject:temporaryStep];
    [parentTutorial replaceObjectInConsistsOfAtIndex:toIndex withObject:tutorialStepFrom];
    [parentTutorial replaceObjectInConsistsOfAtIndex:fromIndex withObject:tutorialStepTo];
    
    [temporaryStep MR_deleteInContext:parentTutorial.managedObjectContext];
    
//    [weakSelf.context MR_saveOnlySelfAndWait];
  };
}

- (void)setupTableViewDataSourceCellDeleteBlock
{
  __weak typeof(self) weakSelf = self;
  _tableViewDataSource.deleteCellOnSwipeBlock = ^(NSIndexPath *indexPath) {
    NSString *message = @"Are you sure you want to delete tutorial step? This action cannot be reverted!";
    [AlertFactory showOKCancelAlertViewWithMessage:message okTitle:@"Yes, delete tutorial step" okAction:^{
      TutorialStep *tutorialStep = [weakSelf.tableViewDataSource objectAtIndexPath:indexPath];
      AssertTrueOrReturn(weakSelf.context);
      [tutorialStep MR_deleteInContext:weakSelf.context];
      [weakSelf.context MR_saveOnlySelfAndWait];
    } cancelAction:^{
      // hide delete button
      [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // TODO: read that value from xib (has to be dependent on tutorialStep type though)
  return kTutorialStepCellHeight;
}

@end
