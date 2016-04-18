@import AVFoundation;
@import Foundation;

@interface AVURLAsset (Duration)

+ (NSTimeInterval)assetDurationInSecondsForURL:(NSURL *)url;
- (NSTimeInterval)durationInSeconds;

@end
