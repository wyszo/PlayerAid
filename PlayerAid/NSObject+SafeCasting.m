@import KZAsserts;
#import "NSObject+SafeCasting.h"

@implementation NSObject (SafeCasting)

- (NSArray *)safeCastToArray {
    AssertTrueOrReturnNil([self isKindOfClass: [NSArray class]]);
    return (NSArray *)self;
}

- (NSDictionary *)safeCastToDictionary {
    AssertTrueOrReturnNil([self isKindOfClass: [NSDictionary class]]);
    return (NSDictionary *)self;
}

@end
