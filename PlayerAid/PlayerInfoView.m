//
//  PlayerAid
//

#import "PlayerInfoView.h"
#import "UIImageView+AvatarStyling.h"
#import "UIView+TWXibLoading.h"
#import "ColorsHelper.h"
#import "AuthenticatedServerCommunicationController.h"
#import "UserManipulationController.h"


static NSString *const kNibFileName = @"PlayerInfoView";

static NSString *const kFollowImageFilename = @"addfriend";
static NSString *const kUnfollowImageFilename = @"addfriend_on";


@interface PlayerInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@property (strong, nonatomic) UIView *view;

@end


@implementation PlayerInfoView

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
    [self setupBackgroundColor];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
    [self setupBackgroundColor];
  }
  return self;
}

- (void)awakeFromNib
{
  [self.avatarImageView styleAsLargeAvatar];
  [self setupBackgroundColor];
}

- (void)setupBackgroundColor
{
  self.contentView.backgroundColor = [ColorsHelper playerAidBlueColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [self.avatarImageView styleAsLargeAvatar];
  [super willMoveToSuperview:newSuperview];
}

#pragma mark - UI Customization

- (void)setUser:(User *)user
{
  _user = user;
  [user placeAvatarInImageView:self.avatarImageView];
  
  self.usernameLabel.text = user.name;
  self.descriptionLabel.text = user.userDescription;

  BOOL isCurrentUser = user.loggedInUserValue;
  self.editButton.hidden = !isCurrentUser;
  self.addFriendButton.hidden = isCurrentUser;
  
  [self updateAddFriendButtonIconForProfileUser];
}

- (void)updateAddFriendButtonIconForProfileUser
{
  if (!self.user.loggedInUserValue) {
    BOOL following = [self loggedInUserFollowsProfileUser];
    NSString *imageName = (following ? kUnfollowImageFilename : kFollowImageFilename);
    [self.addFriendButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
  }
}

- (BOOL)loggedInUserFollowsProfileUser
{
  return [[UserManipulationController new] currentUserFollowsUser:self.user];
}

#pragma mark - IBActions

- (IBAction)editButtonPressed:(id)sender
{
  CallBlock(self.editButtonPressed);
}

- (IBAction)toggleFriendButtonPressed:(id)sender
{
  AssertTrueOrReturn(!self.user.loggedInUserValue);
  
  if (!self.loggedInUserFollowsProfileUser) {
    [[UserManipulationController new] sendFollowUserNetworkRequestAndUpdateDataModel:self.user];
  }
  else {
    [[UserManipulationController new] sendUnfollowUserNetworkRequestAndUpdateDataModel:self.user];
  }
}

@end
