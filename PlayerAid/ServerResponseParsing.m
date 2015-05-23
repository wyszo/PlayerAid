//
//  PlayerAid
//

#import "ServerResponseParsing.h"

@implementation ServerResponseParsing

+ (NSString *)tutorialIDFromResponseObject:(id)responseObject
{
  AssertTrueOrReturnNil([responseObject isKindOfClass:[NSDictionary class]]);
  NSDictionary *dictionary = responseObject;
  return dictionary[@"id"];
}

@end
