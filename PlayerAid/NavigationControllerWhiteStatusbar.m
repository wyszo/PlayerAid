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

@end
