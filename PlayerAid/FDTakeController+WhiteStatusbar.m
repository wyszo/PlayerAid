//
//  PlayerAid
//

@import UIKit;
#import "FDTakeController+WhiteStatusbar.h"

@implementation FDTakeController (WhiteStatusbar)

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [[[viewController navigationController] navigationBar] setBarStyle:UIBarStyleBlack]; // enforces white statusbar
}

@end
