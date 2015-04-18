//
//  PlayerAid
//

#import "ViewControllerPresentationHelper.h"


@implementation ViewControllerPresentationHelper

- (void)presentViewControllerInKeyWindow:(UIViewController *)viewController
{
  AssertTrueOrReturn(viewController);
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  viewController.view.frame = window.frame;
  [window addSubview:viewController.view];
}

@end
