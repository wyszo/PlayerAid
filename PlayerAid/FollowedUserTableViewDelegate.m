//
//  PlayerAid
//

#import "FollowedUserTableViewDelegate.h"
#import "TWCommonLib.h"

static const CGFloat kUserFollowedCellHeight = 88.0f;

@implementation FollowedUserTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kUserFollowedCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CallBlock(self.cellSelectedBlock, indexPath);
  [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

@end
