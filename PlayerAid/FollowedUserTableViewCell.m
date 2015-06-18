//
//  PlayerAid
//

#import "FollowedUserTableViewCell.h"
#import "UIImageView+AvatarStyling.h"


@implementation FollowedUserTableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self.avatarImageView makeCircular];
}

#pragma mark - IBActions

- (IBAction)followUnfollowButtonPressed:(id)sender
{
  NOT_IMPLEMENTED_YET_RETURN
}

@end
