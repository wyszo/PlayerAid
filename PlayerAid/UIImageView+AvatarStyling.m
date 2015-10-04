//
//  PlayerAid
//

@import TWCommonLib;
#import "UIImageView+AvatarStyling.h"

static const CGFloat kSmallAvatarBorderWidth = 1.5f;
static const CGFloat kLargeAvatarBorderWidth = 2.25f;
static const CGFloat kThinAvatarBorderWidth = 1.0f;


@implementation UIImageView (AvatarStyling)

- (void)styleAsSmallAvatar
{
  [self makeCircular];
  [self tw_addBorderWithWidth:kSmallAvatarBorderWidth color:self.borderColor];
}

- (void)styleAsLargeAvatar
{
  [self makeCircular];
  [self tw_addBorderWithWidth:kLargeAvatarBorderWidth color:self.borderColor];
}

- (void)styleAsAvatarThinBorder
{
  [self makeCircular];
  [self tw_addBorderWithWidth:kThinAvatarBorderWidth color:self.borderColor];
}

- (UIColor *)borderColor
{
  return [UIColor whiteColor];
}

- (void)makeCircular
{
  [self tw_setCornerRadius:(self.self.frame.size.width / 2.0f) ];
  self.clipsToBounds = YES;
}

@end
