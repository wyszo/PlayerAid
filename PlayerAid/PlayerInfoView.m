//
//  PlayerAid
//

#import "PlayerInfoView.h"
#import "UIImageView+AvatarStyling.h"
#import "UIView+TWXibLoading.h"
#import "ColorsHelper.h"

static NSString *const kNibFileName = @"PlayerInfoView";


@interface PlayerInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

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
  self.contentView.backgroundColor = [ColorsHelper loginAndPlayerInfoViewBackgroundColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [self.avatarImageView styleAsLargeAvatar];
  [super willMoveToSuperview:newSuperview];
}

#pragma mark - UI Customization

- (void)setUser:(User *)user
{
  [user placeAvatarInImageView:self.avatarImageView];
  
  self.usernameLabel.text = user.name;
  self.descriptionLabel.text = user.userDescription;
  
  self.editButton.hidden = !user.loggedInUserValue;
}

- (IBAction)editButtonPressed:(id)sender
{
  // TODO: push edit view
}

@end
