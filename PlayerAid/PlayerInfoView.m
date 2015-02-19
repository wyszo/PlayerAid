//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "PlayerInfoView.h"
#import "UIImageView+AvatarStyling.h"
#import "UIView+XibLoading.h"

static NSString *const kNibFileName = @"PlayerInfoView";


@interface PlayerInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) UIView *view;

@end

@implementation PlayerInfoView

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

- (void)awakeFromNib
{
  [self.avatarImageView styleAsLargeAvatar];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [self.avatarImageView styleAsLargeAvatar];
  [super willMoveToSuperview:newSuperview];
}

#pragma mark - UI Customization

- (void)setUser:(User *)user
{
// TODO: self.backgroundImageView.image =
  
  [user placeAvatarInImageView:self.avatarImageView];
  
  self.usernameLabel.text = user.name;
  self.descriptionLabel.text = user.userDescription;
}

@end
