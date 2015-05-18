//
//  PlayerAid
//

#import "UIImageView+AvatarStyling.h"

static const CGFloat kSmallAvatarBorderWidth = 1.5f;
static const CGFloat kLargeAvatarBorderWidth = 2.25f;


@implementation UIImageView (AvatarStyling)

- (void)styleAsSmallAvatar
{
  [self makeCircular];
  [self addBorderWithWidth:kSmallAvatarBorderWidth];
}

- (void)styleAsLargeAvatar
{
  [self makeCircular];
  [self addBorderWithWidth:kLargeAvatarBorderWidth];
}

- (void)makeCircular
{
  self.layer.cornerRadius = self.self.frame.size.width / 2;
  self.clipsToBounds = YES;
}

- (void)addBorderWithWidth:(CGFloat)borderWidth
{
  self.layer.borderWidth = borderWidth;
  self.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
