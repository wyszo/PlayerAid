//
//  PlayerAid
//

#import "UITableView+TableViewHelper.h"


@implementation UITableView (TableViewHelper)

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
