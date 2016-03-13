//
//  PlayerAid
//

#import <TWCommonLib/TWInterfaceOrientationViewControllerDecorator.h>
#import "NavigationControllerWhiteStatusbar.h"
#import "TWInterfaceOrientationViewControllerDecorator.h"

@implementation NavigationControllerWhiteStatusbar

+ (void)initialize
{
  [[TWInterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  /** When using hidesBarsOnSwipe on NavigationController, viewController statusbar color has to be the same as NavigationController statusbar color (and prefersStatusBarHidden), otherwise it'll break after showing and dismissing a modal view - navigationBar will permanently be hidden */
  return UIStatusBarStyleLightContent;
}

@end
