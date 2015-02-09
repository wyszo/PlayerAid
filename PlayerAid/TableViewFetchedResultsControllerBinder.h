//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface TableViewFetchedResultsControllerBinder : NSObject <NSFetchedResultsControllerDelegate>

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

/**
 @param configureCellBlock  A block that will be called if dataModel object for item changed (and NSFetchedResultsController got NSFetchedResultsChangeUpdate change notification)
 */
- (instancetype)initWithTableView:(UITableView *)tableView
               configureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock;;

@end
