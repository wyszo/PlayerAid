//
//  PlayerAid
//

#import "YCameraViewController+InterfaceOrientation.h"
#import "TWInterfaceOrientationViewControllerDecorator.h"


@implementation YCameraViewController (InterfaceOrientation)

+ (void)initialize
{
  [[TWInterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

@end
