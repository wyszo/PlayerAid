//
//  PlayerAid
//

#import "TableViewFetchedResultsControllerBinder.h"


@interface TableViewFetchedResultsControllerBinder ()
@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) void (^configureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
@property (strong, nonatomic) NSMutableDictionary *numberOfClassInstanceChangesToBypass;
@end


@implementation TableViewFetchedResultsControllerBinder

#pragma mark - Initialization

- (instancetype)initWithTableView:(UITableView *)tableView configureCellBlock:(void (^)(UITableViewCell *, NSIndexPath *))configureCellBlock
{
  self = [super init];
  if (self) {
    _tableView = tableView;
    _configureCellBlock = configureCellBlock;
  }
  return self;
}

#pragma mark - Ignoring user-driven changes

- (void)registerUserDrivenChangesCount:(NSInteger)changesCount forObjectType:(Class)aClass
{
  NSString *key = NSStringFromClass(aClass);
  NSNumber *changesToBypass = @([self.numberOfClassInstanceChangesToBypass[key] integerValue] + changesCount);
  if (changesToBypass.integerValue < 0) {
    changesToBypass = @0;
  }
  self.numberOfClassInstanceChangesToBypass[NSStringFromClass(aClass)] = changesToBypass;
}

- (void)decrementUserDrivenChangesCountForObject:(NSObject *)object
{
  [self registerUserDrivenChangesCount:-1 forObjectType:object.class];
}

- (BOOL)shouldBypassObjectChange:(NSObject *)anObject
{
  NSString *key = NSStringFromClass(anObject.class);
  return ([self.numberOfClassInstanceChangesToBypass[key] integerValue] > 0);
}

- (NSMutableDictionary *)numberOfClassInstanceChangesToBypass
{
  if (!_numberOfClassInstanceChangesToBypass) {
    _numberOfClassInstanceChangesToBypass = [NSMutableDictionary dictionary];
  }
  return _numberOfClassInstanceChangesToBypass;
}

#pragma mark - NSFetchedResultsControllerDelegate

// source: http://samwize.com/2014/03/29/implementing-nsfetchedresultscontroller-with-magicalrecord/


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  if ([self shouldBypassObjectChange:anObject]) {
    [self decrementUserDrivenChangesCountForObject:anObject];
    return;
  }

  UITableView *tableView = self.tableView;
  AssertTrueOrReturn(tableView);
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert: {
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [self invokeNumberOfObjectsChangedCallbackForController:controller];
    } break;
      
    case NSFetchedResultsChangeDelete: {
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [self invokeNumberOfObjectsChangedCallbackForController:controller];
    } break;
      
    case NSFetchedResultsChangeUpdate: {
      if (self.configureCellBlock) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
          self.configureCellBlock(cell, indexPath);
        } else {
          // FetchedResultsController of a tableView from other tabBar item (now invisible) got the update, but didn't return a new cell when asked (since it's invisible). Expected case, don't worry.
        }
      }
    } break;
      
    case NSFetchedResultsChangeMove: {
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
    } break;
  }
}

- (void)invokeNumberOfObjectsChangedCallbackForController:(NSFetchedResultsController *)fetchedResultsController
{
  if (self.numberOfObjectsChangedBlock) {
    self.numberOfObjectsChangedBlock(fetchedResultsController.fetchedObjects.count);
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  UITableView *tableView = self.tableView;
  AssertTrueOrReturn(tableView);
  
  switch(type) {
    case NSFetchedResultsChangeInsert: {
      [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
               withRowAnimation:UITableViewRowAnimationFade];
    } break;
      
    case NSFetchedResultsChangeDelete: {
      [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
               withRowAnimation:UITableViewRowAnimationFade];
    } break;
      
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
