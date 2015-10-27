//
//  PlayerAid
//

@import KZAsserts;
#import "TutorialTableViewCell+Prefetching.h"

@interface TutorialTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (void)setBackgroundImage:(nonnull UIImage *)image fadeInAnimation:(BOOL)fadeInAnimation;
@end

@implementation TutorialTableViewCell (Prefetching)

- (void)setBackgroundImageIfNil:(nonnull UIImage *)image animated:(BOOL)animated
{
  AssertTrueOrReturn(image);
  
  if (self.backgroundImageView.image == nil) {
    [self setBackgroundImage:image fadeInAnimation:animated];
  }
}

@end
