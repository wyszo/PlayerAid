//
//  PlayerAid
//

#import "ExtendedMPMoviePlayerViewController.h"


@implementation ExtendedMPMoviePlayerViewController

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  if (self.presentInLandscapeOrientation) {
    return UIInterfaceOrientationLandscapeRight;
  }
  return [[UIApplication sharedApplication] statusBarOrientation];
}

@end
