//
//  PlayerAid
//

#import "UIImageView+AvatarStyling.h"

@implementation UIImageView (AvatarStyling)

- (void)styleAsAvatar
{
  [self makeCircular];
  [self addBorder];
}

- (void)makeCircular
{
  self.layer.cornerRadius = self.self.frame.size.width / 2;
  self.clipsToBounds = YES;
}

- (void)addBorder
{
  self.layer.borderWidth = 5.0f;
  self.layer.borderColor = [UIColor greenColor].CGColor;
}

@end
