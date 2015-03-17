//
//  PlayerAid
//

#import "NSURL+URLString.h"

@implementation NSURL (URLString)

+ (NSString *)URLStringWithPath:(NSString *)path baseURL:(NSURL *)baseURL
{
  AssertTrueOrReturnNil(path.length);
  AssertTrueOrReturnNil(baseURL);
  
  return [[NSURL URLWithString:path relativeToURL:baseURL] absoluteString];
}

@end
