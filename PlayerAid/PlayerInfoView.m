//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "PlayerInfoView.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"
#import "AuthenticatedServerCommunicationController.h"
#import "FollowingButtonDecorator.h"
#import "UserManipulationController.h"

static NSString *const kNibFileName = @"PlayerInfoView";

@interface PlayerInfoView ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *addDescription;

@property (strong, nonatomic) UIView *view;
@end

@implementation PlayerInfoView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.avatarImageView styleAsLargeAvatar];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [self.avatarImageView styleAsLargeAvatar];
  [super willMoveToSuperview:newSuperview];
}

#pragma mark - Public

- (void)setBackButtonHidden:(BOOL)hidden {
    self.backButton.hidden = hidden;
}

#pragma mark - UI Customization

- (void)setUser:(User *)user
{
  // TODO: ViewController should set that!

  _user = user;
  [user placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSizeLarge];
  
  self.usernameLabel.text = user.name;
  self.descriptionLabel.text = user.userDescription;
  self.addDescription.hidden = [self shouldHideAddDescriptionButtonForUser:user];
  
  BOOL isCurrentUser = user.loggedInUserValue;
  self.editButton.hidden = !isCurrentUser;
  self.addFriendButton.hidden = isCurrentUser;
  
  [self updateFollowingButtonImageForProfileUser];
}

- (void)updateFollowingButtonImageForProfileUser {
  [[FollowingButtonDecorator new] updateFollowingButtonImage:self.addFriendButton forUser:self.user backgroundType:BackgroundTypeDark];
}

- (BOOL)shouldHideAddDescriptionButtonForUser:(User *)user {
  AssertTrueOrReturnNo(user != nil);
  return user.userDescription.length > 0;
}

#pragma mark - IBActions

- (IBAction)editButtonPressed:(id)sender {
  CallBlock(self.editButtonPressed);
}

- (IBAction)backButtonPressed:(id)sender {
  CallBlock(self.backButtonPressed);
}

- (IBAction)toggleFollowButtonPressed:(id)sender {
  defineWeakSelf();
  [[UserManipulationController new] toggleFollowButtonPressedSendRequestUpdateModelForUser:self.user completion:^(NSError *error) {
    if (!error) {
      [weakSelf updateFollowingButtonImageForProfileUser];
    }
    AssertTrueOrReturn(!error);
  }];
}

- (IBAction)addDescriptionPressed:(id)sender {
  CallBlock(self.editButtonPressed);
}

@end
