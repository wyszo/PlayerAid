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
  return UIStatusBarStyleLightContent;
}

- (void)dismissViewController {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
