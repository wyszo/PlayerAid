//
//  PlayerAid
//

#import "MediaPlayerHelper.h"
#import <AVFoundation/AVFoundation.h>


@implementation MediaPlayerHelper

+ (void)playVideoWithURL:(NSURL *)url fromViewController:(UIViewController *)viewController
{
  AssertTrueOrReturn(url);
  AssertTrueOrReturn(viewController);
  
  MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  [viewController presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

#pragma mark - Video Thumbnails

// TODO: extract this to a separate class
+ (UIImage *)thumbnailImageFromVideoURL:(NSURL *)videoURL
{
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
  AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  imageGenerator.appliesPreferredTrackTransform = YES;
  NSError *error = NULL;
  
  int64_t seconds = 0;
  int32_t timescale = 10;
  CMTime time = CMTimeMake(seconds, timescale);
  
  CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
  UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
  AssertTrueOrReturnNil(thumbnail);
  return thumbnail;
}

@end
