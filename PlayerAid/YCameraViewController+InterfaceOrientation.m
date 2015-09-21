//
//  PlayerAid
//

#import <TWCommonLib/TWInterfaceOrientationViewControllerDecorator.h>
#import "YCameraViewController+InterfaceOrientation.h"


@implementation YCameraViewController (InterfaceOrientation)

+ (void)initialize
{
  [[TWInterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:[self class] shouldAutorotate:NO];
}

@end
