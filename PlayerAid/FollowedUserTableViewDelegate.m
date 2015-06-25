//
//  PlayerAid
//

#import "FollowedUserTableViewDelegate.h"


static const CGFloat kUserFollowedCellHeight = 88.0f;

@implementation FollowedUserTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kUserFollowedCellHeight;
}

@end
