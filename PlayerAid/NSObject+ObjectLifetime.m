//
//  PlayerAid
//

#import "NSObject+ObjectLifetime.h"
#import <objc/runtime.h>


@implementation NSObject (ObjectLifetime)

- (void)bindLifetimeTo:(NSObject *)owner
{
  AssertTrueOrReturn(owner);
  objc_setAssociatedObject(owner, self.associatedObjectKey, self, OBJC_ASSOCIATION_RETAIN);
}

- (void)releaseLifetimeDependencyFrom:(NSObject *)owner
{
  objc_setAssociatedObject(owner, self.associatedObjectKey, nil, OBJC_ASSOCIATION_RETAIN);
}

- (SEL)associatedObjectKey
{
  return _cmd; // selectors are unique and constant, can be used as associated object key
}

@end
