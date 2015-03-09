//
//  PlayerAid
//

#import "UIView+FadeAnimations.h"

@implementation UIView (FadeAnimations)

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration
{
  [UIView animateWithDuration:duration animations:^{
    self.alpha = 0.0f;
  } completion:^(BOOL finished) {
    self.hidden = YES;
  }];
}

@end
