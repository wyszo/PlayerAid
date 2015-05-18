#import "User.h"


@interface User ()

@end


@implementation User

- (UIImage *)avatarImage
{
  return [UIImage imageWithData:self.avatar];
}

@end
