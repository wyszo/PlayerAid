//
//  PlayerAid
//

@import UIKit;
#import "GuidesTableDataSource.h"


/**
 Ensures images on a timeline are moved from disk cache to in-memory AFNetworking cache before they're needed to be displayed
 */
@interface ImagesPrefetchingController : NSObject

NEW_AND_INIT_UNAVAILABLE
- (nonnull instancetype)initWithDataSource:(nonnull GuidesTableDataSource *)dataSource tableView:(nonnull UITableView *)tableView;

// need to be called manually from tableViewDelegate
- (void)willDisplayCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

// need to be called manually from tableViewDelegate
- (void)didEndDisplayingCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath withTutorial:(nonnull Tutorial *)tutorial;

@end
