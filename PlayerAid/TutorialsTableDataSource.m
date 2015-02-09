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


static NSString *const kTutorialCellReuseIdentifier = @"TutorialCell";


@interface CoreDataTableViewDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) NSFetchedResultsController* (^fetchedResultsControllerLazyInitializationBlock)();
@property (copy, nonatomic) void (^deleteCellOnSwipeBlock)(NSIndexPath *indexPath);


- (instancetype)initWithConfigureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock;
- (void)resetFetchedResultsController;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface CoreDataTableViewDataSource ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) void (^configureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);

@end


@implementation CoreDataTableViewDataSource

#pragma mark - Initialization

- (instancetype)initWithConfigureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock
{
  self = [super init];
  if (self) {
    _configureCellBlock = configureCellBlock;
  }
  return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self sectionInfoForSection:section].numberOfObjects;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self sectionInfoForSection:section].name;
}

- (id<NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSInteger)section
{
  return self.fetchedResultsController.sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTutorialCellReuseIdentifier];
  
  if (self.configureCellBlock) {
    self.configureCellBlock(cell, indexPath);
  }
  return cell;
}

#pragma mark - Deleting cells

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return (self.deleteCellOnSwipeBlock != nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.deleteCellOnSwipeBlock && editingStyle == UITableViewCellEditingStyleDelete) {
    self.deleteCellOnSwipeBlock(indexPath);
  }
}

#pragma mark - Lazy Initialization

- (NSFetchedResultsController *)fetchedResultsController
{
  if (!_fetchedResultsController) {
    if (self.fetchedResultsControllerLazyInitializationBlock) {
      _fetchedResultsController = self.fetchedResultsControllerLazyInitializationBlock();
    }
  }
  return _fetchedResultsController;
}

#pragma mark - Other methods

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoForSection:indexPath.section];
  AssertTrueOrReturnNil(sectionInfo.objects.count > indexPath.row);
  return sectionInfo.objects[indexPath.row];
}

- (void)resetFetchedResultsController
{
  _fetchedResultsController = nil;
}

@end



@interface TutorialsTableDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) CoreDataTableViewDataSource *tableViewDataSource;
@end


@implementation TutorialsTableDataSource

#pragma mark - Initilization

- (instancetype)initWithTableView:(UITableView *)tableView
{
  // TODO: pass a predicate and groupBy in initializer, so we don't reload tableView unnecessarily after setting predicate and groupBy
  self = [super init];
  if (self) {
    _tableView = tableView;
    
    [self initTableViewDataSource];
    _tableView.delegate = self;
    
    UINib *tableViewCellNib = [TutorialCellHelper nibForTutorialCell];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kTutorialCellReuseIdentifier];
  }
  return self;
}

- (void)initTableViewDataSource
{
  __weak typeof(self) weakSelf = self;
  
  _tableViewDataSource = [[CoreDataTableViewDataSource alloc] initWithConfigureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  }];
  _tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    return [Tutorial MR_fetchAllSortedBy:@"state,createdAt" ascending:YES withPredicate:weakSelf.predicate groupBy:weakSelf.groupBy delegate:weakSelf];
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

#pragma mark - NSFetchedResultsControllerDelegate

// source: http://samwize.com/2014/03/29/implementing-nsfetchedresultscontroller-with-magicalrecord/


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeMove:
    case NSFetchedResultsChangeUpdate:
      break;
  }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

@end
