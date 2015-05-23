//
//  PlayerAid
//

@interface UIView (FadeAnimations)

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration;
- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration;
- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
