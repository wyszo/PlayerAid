//
//  PlayerAid
//

@interface TutorialsTableFetchedResultsControllersFactory : NSObject

/**
 * Returns FRC sorted by 'state' ascending and 'createdAt' descending
 */
- (NSFetchedResultsController *)tutorialsTableFetchedResultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate predicate:(NSPredicate *)predicate groupBy:(NSString *)groupBy InContext:(NSManagedObjectContext *)context;

@end
