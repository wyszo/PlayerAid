//
//  PlayerAid
//


#import "TableViewFetchedResultsControllerBinder.h"
#import <KZAsserts.h>


@interface TableViewFetchedResultsControllerBinder ()
@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) void (^configureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
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

#pragma mark - NSFetchedResultsControllerDelegate

// source: http://samwize.com/2014/03/29/implementing-nsfetchedresultscontroller-with-magicalrecord/


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  AssertTrueOrReturn(tableView);
  
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
      if (self.configureCellBlock) {
        self.configureCellBlock([tableView cellForRowAtIndexPath:indexPath], indexPath);
      }
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
  UITableView *tableView = self.tableView;
  AssertTrueOrReturn(tableView);
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
               withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
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