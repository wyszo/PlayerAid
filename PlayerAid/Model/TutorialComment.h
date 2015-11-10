#import "_TutorialComment.h"
#import <TWCommonLib/TWConfigurableFromDictionary.h>

@interface TutorialComment : _TutorialComment <TWConfigurableFromDictionary>

#pragma mark - Class methods

+ (nullable NSNumber *)serverIDFromTutorialCommentDictionary:(nonnull NSDictionary *)dictionary;
+ (nonnull TutorialComment *)findFirstOrCreateByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context;

@end
