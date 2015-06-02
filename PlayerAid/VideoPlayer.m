//
//  PlayerAid
//

#import "VideoPlayer.h"
#import "ExtendedMPMoviePlayerViewController.h"


// TODO: migrate to AVPlayerViewController as MPMoviePlayerPlaybackDidFinishNotification is not handled correctly on iOS8 (not invoked in case of URL resource error)
// TODO: test error and dismiss view controller
// TODO: test loss of internet connection


@interface VideoPlayer()

@property (nonatomic, strong) ExtendedMPMoviePlayerViewController *videoPlayerController;
@property (nonatomic, weak) UIViewController *parent;

@end


@implementation VideoPlayer

- (instancetype)initWithParentViewController:(UIViewController *)parentViewController
{
  AssertTrueOrReturnNil(parentViewController);
  if (self == [super init]) {
    _parent = parentViewController;
  }
  return self;
}

- (void)presentMoviePlayerAndPlayVideoURL:(NSURL *)videoURL
{
  AssertTrueOrReturn(videoURL);
  self.videoPlayerController = [[ExtendedMPMoviePlayerViewController alloc] initWithContentURL:videoURL];
  
  MPMoviePlayerController *moviePlayer = self.videoPlayerController.moviePlayer;
  moviePlayer.shouldAutoplay = YES;
  [moviePlayer prepareToPlay];

  AssertTrueOrReturn(self.parent);
  [self.parent presentMoviePlayerViewControllerAnimated:self.videoPlayerController];
}

@end
