//
//  PlayerAid
//

@import TWCommonLib;
#import "KZPropertyMapper+TZDDateBoxing.h"

@implementation KZPropertyMapper (TZDDateBoxing)

+ (NSDate *)boxValueAsDateWithTZD:(id)value __unused
{
  if (value == nil) {
    return nil;
  }
  AssertTrueOrReturnNil([value isKindOfClass:NSString.class]);
  NSString *dateString = value;
  dateString = [dateString tw_stringByRemovingLastOccurrenceOfString:@":" fromLastNumberOfCharacters:3];
  
  return [[self dateFormatter] dateFromString:dateString];
}

+ (NSDateFormatter *)dateFormatter
{
  static NSDateFormatter *df = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    df = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [df setLocale:locale];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
  });
  return df;
}

@end
