#import "VideoDurationFormatter.h"

@implementation VideoDurationFormatter

- (NSString *)formatDurationInSeconds:(NSTimeInterval)durationInSeconds {
  if (durationInSeconds < 1) {
    return @"";
  }

  long durationInMinutes = (NSInteger)(durationInSeconds / 60);
  long remainingSeconds = (NSInteger)durationInSeconds % 60;
  
  return [NSString stringWithFormat:@"%ld:%02ld", durationInMinutes, remainingSeconds];
}

@end
