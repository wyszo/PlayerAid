//
//  PlayerAid
//

#import "NavigationControllerWhiteStatusbar.h"
#import "InterfaceOrientationViewControllerDecorator.h"


@implementation NavigationControllerWhiteStatusbar

+ (void)initialize
{
  [[InterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

@end
