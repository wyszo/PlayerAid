//
//  PlayerAid
//

#import "NSString+Trimming.h"

@implementation NSString (Trimming)

- (NSString *)stringByRemovingLastOccurrenceOfString:(NSString *)stringToReplace fromLastNumberOfCharacters:(NSInteger)characterRange
{
  AssertTrueOrReturnNil(stringToReplace.length);
  AssertTrueOrReturnNil(characterRange > 0);
  if (!self.length) {
    return nil;
  }
  NSString *resultString = self;
  
  NSRange lastOccurrenceRange = [resultString rangeOfString:stringToReplace options:NSBackwardsSearch];
  if (lastOccurrenceRange.location >= resultString.length - characterRange) {
    resultString = [resultString stringByReplacingCharactersInRange:lastOccurrenceRange withString:@""];
  }
  return resultString;
}

@end
