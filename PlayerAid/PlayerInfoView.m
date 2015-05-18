//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "PlayerInfoView.h"
#import "UIImageView+AvatarStyling.h"

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
  [self.avatarImageView styleAsAvatar];
}

- (void)xibSetup
{
  self.view = [self loadViewFromNib];
  self.view.frame = self.bounds;
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:self.view];
}

- (UIView *)loadViewFromNib
{
  // TODO: extract this to a separate category
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  UINib *nib = [UINib nibWithNibName:kNibFileName bundle:bundle];
  const NSUInteger viewIndexInXib = 0;
  NSArray *nibViews = [nib instantiateWithOwner:self options:nil];
  AssertTrueOrReturnNil(nibViews.count > viewIndexInXib);
  UIView *view = nibViews[viewIndexInXib];
  return view;
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
