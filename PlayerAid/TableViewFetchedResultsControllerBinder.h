//
//  PlayerAid
//


@interface TableViewFetchedResultsControllerBinder : NSObject <NSFetchedResultsControllerDelegate>

@property (copy, nonatomic) void (^numberOfObjectsChangedBlock)(NSInteger objectCount);

NEW_AND_INIT_UNAVAILABLE

/**
 @param configureCellBlock  A block that will be called if dataModel object for item changed (and NSFetchedResultsController got NSFetchedResultsChangeUpdate change notification)
 */
- (instancetype)initWithTableView:(UITableView *)tableView
               configureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock;;

@end
