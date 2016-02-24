#import "_TutorialComment.h"
#import <TWCommonLib/TWConfigurableFromDictionary.h>

typedef NS_ENUM(NSUInteger, CommentStatus) {
  CommentStatusPublished,
  CommentStatusReported,
  CommentStatusDeleted,
  CommentStatusUnknown
};

@interface TutorialComment : _TutorialComment <TWConfigurableFromDictionary>

@property (nonatomic, assign, readonly) BOOL isCommentDeleted;

#pragma mark - Class methods

+ (nullable NSNumber *)serverIDFromTutorialCommentDictionary:(nonnull NSDictionary *)dictionary;

+ (nonnull TutorialComment *)findFirstByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context;
+ (nonnull TutorialComment *)findFirstOrCreateByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context;

@end
