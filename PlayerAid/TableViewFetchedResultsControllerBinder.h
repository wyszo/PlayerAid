//
//  PlayerAid
//


@interface TableViewFetchedResultsControllerBinder : NSObject <NSFetchedResultsControllerDelegate>

@property (copy, nonatomic) void (^numberOfObjectsChangedBlock)(NSInteger objectCount);

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

/**
 @param configureCellBlock  A block that will be called if dataModel object for item changed (and NSFetchedResultsController got NSFetchedResultsChangeUpdate change notification)
 */
- (instancetype)initWithTableView:(UITableView *)tableView
               configureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock;;

/**
 FetchedResultsController is supposed to react to model changes, if user changed UI, we need to just update model, bypassing NSFetchedResultsControllerDelegate updates. This method asks the binder to do that.
 
 @param changesCount  how many changes to objects of a specified type should we ignore
 @param aClass  a class that we'll be ingoring instances of
 */
- (void)registerUserDrivenChangesCount:(NSInteger)changesCount forObjectType:(Class)aClass;

@end
