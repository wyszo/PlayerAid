//
//  PlayerAid
//

#import "UIImageView+AvatarStyling.h"

@implementation UIImageView (AvatarStyling)

- (void)styleAsSmallAvatar
{
  [self makeCircular];
  [self addBorderWithWidth:1.5f];
}

- (void)styleAsLargeAvatar
{
  [self makeCircular];
  [self addBorderWithWidth:2.25f];
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
