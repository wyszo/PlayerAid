//
//  PlayerAid
//

#import "NSError+PlayerAidErrors.h"


static NSString *const kPlayerAidServerDomain = @"PlayerAidServer";


@implementation NSError (PlayerAidErrors)

+ (NSError *)genericServerResponseError
{
  const NSInteger kIncorrectResponseErrorCode = 500;
  return [[NSError alloc] initWithDomain:kPlayerAidServerDomain code:kIncorrectResponseErrorCode userInfo:nil];
}

+ (NSError *)incorrectServerResponseError
{
  const NSInteger kIncorrectResponseErrorCode = 501;
  return [[NSError alloc] initWithDomain:kPlayerAidServerDomain code:kIncorrectResponseErrorCode userInfo:nil];
}

@end
