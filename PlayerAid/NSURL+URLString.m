//
//  PlayerAid
//

#import "NSURL+URLString.h"

@implementation NSURL (URLString)

+ (NSString *)URLStringWithPath:(NSString *)path baseURL:(NSURL *)baseURL
{
  return [[self.class URLWithPath:path baseURL:baseURL] absoluteString];
}

+ (NSURL *)URLWithPath:(NSString *)path baseURL:(NSURL *)baseURL
{
  AssertTrueOrReturnNil(path.length);
  AssertTrueOrReturnNil(baseURL);
  
  return [NSURL URLWithString:path relativeToURL:baseURL];
}

@end
