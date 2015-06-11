//
//  PlayerAid
//

#import "UITabBarControllerWithAutorotate.h"
#import "TWInterfaceOrientationViewControllerDecorator.h"


@implementation UITabBarControllerWithAutorotate

+ (void)initialize
{
  [[TWInterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

@end
