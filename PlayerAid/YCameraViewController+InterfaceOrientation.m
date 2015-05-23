//
//  PlayerAid
//

#import "YCameraViewController+InterfaceOrientation.h"
#import "InterfaceOrientationViewControllerDecorator.h"


@implementation YCameraViewController (InterfaceOrientation)

+ (void)initialize
{
  [[InterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

@end
