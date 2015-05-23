//
//  PlayerAid
//

#import "UITabBarControllerWithAutorotate.h"
#import "InterfaceOrientationViewControllerDecorator.h"


@implementation UITabBarControllerWithAutorotate

+ (void)initialize
{
  [[InterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

@end
