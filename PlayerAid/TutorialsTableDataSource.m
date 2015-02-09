//
//  PlayerAid
//

#import <CoreData/CoreData.h>
#import <NSManagedObject+MagicalFinders.h>
#import <MagicalRecord+Actions.h>
#import <NSManagedObject+MagicalRecord.h>
#import <KZAsserts.h>
#import "TutorialsTableDataSource.h"
#import "Tutorial.h"
#import "TutorialTableViewCell.h"
#import "ServerCommunicationController.h"
#import "TutorialCellHelper.h"
#import "CoreDataTableViewDataSource.h"
#import "TableViewFetchedResultsControllerBinder.h"


static NSString *const kTutorialCellReuseIdentifier = @"TutorialCell";


@interface TutorialsTableDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) CoreDataTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) TableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@end


@implementation TutorialsTableDataSource

#pragma mark - Initilization

- (instancetype)initWithTableView:(UITableView *)tableView
{
  self = [super init];
  if (self) {
    _tableView = tableView;
    
    [self initFetchedResultsControllerBinder];
    [self initTableViewDataSource];
    
    _tableView.delegate = self;
    [_tableView registerNib:[TutorialCellHelper nibForTutorialCell] forCellReuseIdentifier:kTutorialCellReuseIdentifier];
  }
  return self;
}

- (void)initFetchedResultsControllerBinder
{
  __weak typeof(self) weakSelf = self;
  _fetchedResultsControllerBinder = [[TableViewFetchedResultsControllerBinder alloc] initWithTableView:_tableView configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  }];
}

- (void)initTableViewDataSource
{
  __weak typeof(self) weakSelf = self;
  
  _tableViewDataSource = [[CoreDataTableViewDataSource alloc] initWithCellreuseIdentifier:kTutorialCellReuseIdentifier configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  }];
  _tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    return [Tutorial MR_fetchAllSortedBy:@"state,createdAt" ascending:YES withPredicate:weakSelf.predicate groupBy:weakSelf.groupBy delegate:weakSelf.fetchedResultsControllerBinder];
  };
  _tableView.dataSource = _tableViewDataSource;
}

#pragma mark - Handling CoreData fetching

- (void)setPredicate:(NSPredicate *)predicate
{
  if (predicate != _predicate) {
    _predicate = predicate;
    
    [self.tableViewDataSource resetFetchedResultsController];
    [self.tableView reloadData];
  }
}

- (void)setGroupBy:(NSString *)groupBy
{
  if (groupBy != _groupBy) {
    _groupBy = groupBy;
    
    [self.tableViewDataSource resetFetchedResultsController];
    [self.tableView reloadData];
  }
}

#pragma mark - Cell configuration

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn([cell isKindOfClass:[TutorialTableViewCell class]]);
  TutorialTableViewCell *tutorialCell = (TutorialTableViewCell *)cell;
  Tutorial *tutorial = [self.tableViewDataSource objectAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [tutorialCell configureWithTutorial:tutorial];
}

#pragma mark - DataSource - deleting cells

- (BOOL)swipeToDeleteEnabled
{
  return (self.tableViewDataSource.deleteCellOnSwipeBlock != nil);
}

- (void)setSwipeToDeleteEnabled:(BOOL)swipeToDeleteEnabled
{
  __weak typeof(self) weakSelf = self;
  _tableViewDataSource.deleteCellOnSwipeBlock = ^(NSIndexPath *indexPath) {
    [weakSelf deleteTutorialAtIndexPath:indexPath];
  };
}

- (void)deleteTutorialAtIndexPath:(NSIndexPath *)indexPath
{
  // TODO: delete tutorial behaviour should be different on different profile tableView filters - current behaviour is correct only for list of tutorials created by a user
  
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  
  // Make a delete tutorial network request
  [ServerCommunicationController.sharedInstance deleteTutorial:tutorial completion:^(NSError *error) {
    if (error) {
      // TODO: delete tutorial request failed, queue it again, retry
    }
  }];
  
  // Remove tutorial object from CoreData, tableView will automatically pick up the change
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    Tutorial *tutorialInLocalContext = [tutorial MR_inContext:localContext];
    [tutorialInLocalContext MR_deleteInContext:localContext];
  }];
}

#pragma mark - Auxiliary methods

- (Tutorial *)tutorialAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.tableViewDataSource objectAtIndexPath:indexPath];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [self.tutorialTableViewDelegate didSelectRowWithTutorial:tutorial];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [TutorialCellHelper cellHeightFromNib];
}

@end
