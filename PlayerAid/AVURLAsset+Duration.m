@import KZAsserts;
#import "AVURLAsset+Duration.h"

@implementation AVURLAsset (Duration)

+ (NSTimeInterval)assetDurationInSecondsForURL:(NSURL *)url {
  AssertTrueOr(url, return 0.0;);
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
  return asset.durationInSeconds;
}

- (NSTimeInterval)durationInSeconds {
  return CMTimeGetSeconds(self.duration);
}

@end
