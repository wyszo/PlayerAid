#import "_Tutorial.h"

@interface Tutorial (Clone)

/**
 Returns an array of names of the classes, that should not be cloned with a deep copy when the object itself is cloned
 */
+ (NSArray *)entityClassNamesThatAllowOnlyShallowCopy;

/**
 Returns an array of classes, that should not be cloned with a deep copy when the object itself is cloned
 */
+ (NSArray *)entitiesClassesThatAllowOnlyShallowCopy;

@end
