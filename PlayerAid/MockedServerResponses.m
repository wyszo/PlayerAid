//
//  PlayerAid
//

#import "MockedServerResponses.h"


@implementation MockedServerResponses

+ (NSDictionary *)postUserResponse
{
  id json = [self objectForJsonFileNamed:@"user.json"];
  AssertTrueOrReturnNil([json isKindOfClass:[NSDictionary class]]);
  return json;
}

+ (id)objectForJsonFileNamed:(NSString *)fileName
{
  NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:fileName ofType:nil];
  AssertTrueOrReturnNil(path);
  
  NSData *jsonData = [NSData dataWithContentsOfFile:path];
  id json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
  return json;
}

@end
