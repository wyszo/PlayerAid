//
//  PlayerAid
//

#import "VideoThumbnailHelper.h"
#import <AVFoundation/AVFoundation.h>


@implementation VideoThumbnailHelper

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
