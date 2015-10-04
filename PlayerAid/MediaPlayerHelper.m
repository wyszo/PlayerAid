//
//  PlayerAid
//

@import KZAsserts;
#import "MediaPlayerHelper.h"

@implementation MediaPlayerHelper

+ (void)playVideoWithURL:(NSURL *)url fromViewController:(UIViewController *)viewController
{
  AssertTrueOrReturn(url);
  AssertTrueOrReturn(viewController);
  
  MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  [viewController presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

@end
