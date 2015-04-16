//
//  PlayerAid
//

#import "NavigationControllerWhiteStatusbar.h"


@implementation NavigationControllerWhiteStatusbar

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
  return _shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
  if (self.shouldAutorotate) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
  }
  else {
    return UIInterfaceOrientationMaskPortrait;
  }
}

@end
