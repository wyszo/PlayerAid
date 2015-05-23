//
//  PlayerAid
//

#import "NSSet+SetByRemoving.h"


@implementation NSSet (SetByRemovingSet)

- (NSSet *)setByRemovingObjectsInSet:(NSSet *)setToRemove
{
  if (setToRemove.count == 0) {
    return self;
  }
  
  NSMutableSet *mutableSet = [self mutableCopy];
  [mutableSet minusSet:setToRemove];
  return [mutableSet copy];
}

@end
