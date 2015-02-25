//
//  PlayerAid
//

#import "TutorialsTableDataSource.h"
#import "Tutorial.h"
#import "TutorialTableViewCell.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialCellHelper.h"
#import "CoreDataTableViewDataSource.h"
#import "TableViewFetchedResultsControllerBinder.h"
#import "TutorialSectionHeaderView.h"
#import "AlertFactory.h"
#import "UITableView+TableViewHelper.h"


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
  _fetchedResultsControllerBinder.numberOfObjectsChangedBlock = ^(NSInteger objectCount){
    if ([(NSObject *)(weakSelf.tutorialTableViewDelegate) respondsToSelector:@selector(numberOfRowsDidChange:)]) {
      [weakSelf.tutorialTableViewDelegate numberOfRowsDidChange:objectCount];
    }
  };
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
  AssertTrueOrReturn(cell);
  AssertTrueOrReturn([cell isKindOfClass:[TutorialTableViewCell class]]);
  TutorialTableViewCell *tutorialCell = (TutorialTableViewCell *)cell;
  Tutorial *tutorial = [self.tableViewDataSource objectAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [tutorialCell configureWithTutorial:tutorial];
 
  BOOL isLastCellInTableView = [indexPath isEqual:[self.tableViewDataSource lastTableViewCellIndexPath]];
  tutorialCell.showBottomGap = !isLastCellInTableView;
  tutorialCell.canBeDeletedOnSwipe = self.swipeToDeleteEnabled;
  
  tutorialCell.tutorialFavouritedBlock = ^(BOOL favourited) {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      Tutorial *tutorialInContext = [tutorial MR_inContext:localContext];
      tutorialInContext.favouritedValue = favourited;
    }];
    // TODO: make a network request to favourite/unfavourite on server
  };
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
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  if (tutorial.draftValue) {
    [self showDeleteDraftTutorialAlertViewForTutorialAtIndexPath:indexPath];
    return;
  }
  
  // in review or published tutorial - ask for confirmation
  __weak typeof(self) weakSelf = self;
  [AlertFactory showDeleteTutorialAlertConfirmationWithOkAction:^{
    [weakSelf makeDeleteTutorialNetworkRequestForTutorial:tutorial];
  } cancelAction:^{
    [weakSelf.tableView reloadRowAtIndexPath:indexPath];
  }];
}

- (void)makeDeleteTutorialNetworkRequestForTutorial:(Tutorial *)tutorial
{
  // Make a delete tutorial network request for in review/published tutorials
  [AuthenticatedServerCommunicationController.sharedInstance deleteTutorial:tutorial completion:^(NSError *error) {
    if (error) {
      // TODO: queue and retry delete tutorial reqeust!
      [AlertFactory showOKAlertViewWithMessage:@"<Delete tutorial request failed, retrying not implemented yet!>"];
    }
    else {
      // Remove tutorial object from CoreData, tableView will automatically pick up the change
      [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Tutorial *tutorialInLocalContext = [tutorial MR_inContext:localContext];
        [tutorialInLocalContext MR_deleteInContext:localContext];
      }];
      
      [AlertFactory showOKAlertViewWithMessage:@"<Tutorial removed from server!>"];
    }
  }];
}

- (void)showDeleteDraftTutorialAlertViewForTutorialAtIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn(indexPath);
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  
  __weak typeof(self) weakSelf = self;
  [AlertFactory showDeleteTutorialAlertConfirmationWithOkAction:^{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      [[tutorial MR_inContext:localContext] MR_deleteEntity];
    }];
  } cancelAction:^{
    [weakSelf.tableView reloadRowAtIndexPath:indexPath];
  }];
}

#pragma mark - Auxiliary methods

- (Tutorial *)tutorialAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.tableViewDataSource objectAtIndexPath:indexPath];
}

- (NSInteger)totalNumberOfCells
{
  AssertTrueOr(self.tableViewDataSource, return 0;);
  return self.tableViewDataSource.objectCount;
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
  BOOL withBottomGap = ![indexPath isEqual:[self.tableViewDataSource lastTableViewCellIndexPath]];
  return [TutorialTableViewCell cellHeightForCellWithBottomGap:withBottomGap];
}

#pragma mark - TableView Delegate: Section headers

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  if (self.showSectionHeaders) {
    return [self sectionHeaderViewForSection:section];
  }
  else {
    return nil;
  }
}

- (TutorialSectionHeaderView *)sectionHeaderViewForSection:(NSInteger)section
{
  TutorialSectionHeaderView *sectionHeaderView = [[TutorialSectionHeaderView alloc] init];
  
  id<NSFetchedResultsSectionInfo> sectionInfo = [self.tableViewDataSource sectionInfoForSection:section];
  NSString *sectionName = sectionInfo.name;
  AssertTrueOr(sectionName.length, ;);
  
  sectionHeaderView.titleLabel.text = sectionName;
  return sectionHeaderView;
}

- (NSInteger)numberOfRowsForSectionNamed:(NSString *)sectionName
{
  AssertTrueOr(sectionName.length, return 0;);
  
  NSInteger sectionsCount = self.tableViewDataSource.sectionsCount;
  for (int sectionIndex=0; sectionIndex < sectionsCount; sectionIndex++) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.tableViewDataSource sectionInfoForSection:sectionIndex];
    if ([sectionInfo.name.lowercaseString isEqual:sectionName.lowercaseString]) {
      return sectionInfo.numberOfObjects;
    }
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if (self.showSectionHeaders) {
    const CGFloat kSectionHeaderHeight = 32.0f;
    return kSectionHeaderHeight;
  }
  return 0.0;
}

@end
