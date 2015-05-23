//
//  PlayerAid
//

#import "UIView+FadeAnimations.h"

@implementation UIView (FadeAnimations)

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration
{
  [self fadeInAnimationWithDuration:duration completion:nil];
}

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
  if (duration == 0.0f) {
    return;
  }
  self.alpha = 0.0f;
  [UIView animateWithDuration:duration animations:^{
    self.alpha = 1.0f;
  } completion:completion];
}

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration
{
  [self fadeOutAnimationWithDuration:duration completion:nil];
}

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
  if (duration == 0.0f) {
    return;
  }
  [UIView animateWithDuration:duration animations:^{
    self.alpha = 0.0f;
  } completion:^(BOOL finished) {
    self.hidden = YES;
    if (completion) {
      completion(finished);
    }
  }];
}

@end
