//
//  PlayerAid
//

#import "VideoPlayer.h"
#import <MediaPlayer/MediaPlayer.h>


// TODO: test error and dismiss view controller
// TODO: test loss of internet connection


@interface VideoPlayer()

@property (nonatomic, strong) MPMoviePlayerViewController *videoPlayerController;
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
  self.videoPlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
  
  MPMoviePlayerController *moviePlayer = self.videoPlayerController.moviePlayer;
  moviePlayer.shouldAutoplay = YES;
  [moviePlayer prepareToPlay];

  AssertTrueOrReturn(self.parent);
  [self.parent presentMoviePlayerViewControllerAnimated:self.videoPlayerController];
}

@end
