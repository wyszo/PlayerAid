//
//  PlayerAid
//

#import "NSError+PlayerAidErrors.h"


@implementation NSError (PlayerAidErrors)

+ (NSError *)incorrectServerResponseError
{
  const NSInteger kIncorrectResponseErrorCode = 300;
  return [[NSError alloc] initWithDomain:@"PlayerAidServer" code:kIncorrectResponseErrorCode userInfo:nil];
}

@end
