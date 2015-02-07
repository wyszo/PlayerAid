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
    [self xibSetup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self xibSetup];
  }
  return self;
}

- (void)awakeFromNib
{
  [self.avatarImageView styleAsLargeAvatar];
}

- (void)xibSetup
{
  self.view = [UIView viewFromNibNamed:kNibFileName withOwner:self];
  self.view.frame = self.bounds;
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:self.view];
}

#pragma mark - UI Customization

- (void)setUser:(User *)user
{
// TODO: self.backgroundImageView.image =
  self.avatarImageView.image = user.avatarImage;
  self.usernameLabel.text = user.username;
  self.descriptionLabel.text = user.userDescription;
}

@end
