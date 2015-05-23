//
//  PlayerAid
//

#import "UIView+FadeAnimations.h"

@implementation UIView (FadeAnimations)

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration
{
  if (duration == 0.0f) {
    return;
  }
  self.alpha = 0.0f;
  [UIView animateWithDuration:duration animations:^{
    self.alpha = 1.0f;
  }];
}

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration
{
  if (duration == 0.0f) {
    return;
  }
  [UIView animateWithDuration:duration animations:^{
    self.alpha = 0.0f;
  } completion:^(BOOL finished) {
    self.hidden = YES;
  }];
}

@end
