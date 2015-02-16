//
//  PlayerAid
//

#import "PresentAsModalNoAnimationSegue.h"
#import <KZAsserts.h>


@implementation PresentAsModalNoAnimationSegue

- (void)perform
{
  UINavigationController *controller = [[self sourceViewController] navigationController];
  AssertTrueOrReturn(controller);
  [controller presentViewController:self.destinationViewController animated:NO completion:nil];
}

@end
