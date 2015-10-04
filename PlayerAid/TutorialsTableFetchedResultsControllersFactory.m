//
//  PlayerAid
//

@import KZAsserts;
#import "TutorialsTableFetchedResultsControllersFactory.h"


@implementation TutorialsTableFetchedResultsControllersFactory

- (NSFetchedResultsController *)tutorialsTableFetchedResultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate predicate:(NSPredicate *)predicate groupBy:(NSString *)groupBy InContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(delegate);
  AssertTrueOrReturnNil(context);
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tutorial"];
  fetchRequest.predicate = predicate;
  fetchRequest.sortDescriptors = [self tutorialsSortDescriptors];
  
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:groupBy cacheName:nil];
  fetchedResultsController.delegate = delegate;
  
  return fetchedResultsController;
}

#pragma mark - Private

- (NSArray *)tutorialsSortDescriptors
{
  NSSortDescriptor *stateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"state" ascending:YES];
  NSSortDescriptor *createdAtSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
  NSArray *sortDescriptors = @[ stateSortDescriptor, createdAtSortDescriptor ];
  return sortDescriptors;
}

@end
