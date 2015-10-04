//
//  PlayerAid
//

@import KZAsserts;
#import "ServerResponseParsing.h"

@implementation ServerResponseParsing

+ (NSString *)tutorialIDFromResponseObject:(id)responseObject
{
  AssertTrueOrReturnNil([responseObject isKindOfClass:[NSDictionary class]]);
  NSDictionary *dictionary = responseObject;
  NSNumber* idNumber = dictionary[@"id"];
  return [idNumber stringValue];
}

@end
