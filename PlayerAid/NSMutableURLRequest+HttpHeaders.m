//
//  PlayerAid
//

#import "NSMutableURLRequest+HttpHeaders.h"

@implementation NSMutableURLRequest (HttpHeaders)

- (void)addHttpHeadersFromDictionary:(NSDictionary *)httpHeaders
{
  AssertTrueOrReturn(httpHeaders.count);
  
  [httpHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
    NSString *value = httpHeaders[key];
    [self addValue:value forHTTPHeaderField:key];
  }];
}

@end
