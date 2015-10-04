//
//  PlayerAid
//

@import UIKit;
#import "User.h"

@interface FollowedUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;

- (void)configureWithUser:(User *)user;

@end
