#import "_Tutorial.h"

extern NSString *const kTutorialStatePublished;
extern NSString *const kTutorialDictionaryServerIDPropertyName;


@interface Tutorial : _Tutorial {}

@property (nonatomic, strong) NSNumber *draft;
@property (nonatomic, strong) NSNumber *inReview;
@property (nonatomic, assign) BOOL storedOnServer;
@property (nonatomic, assign, readonly) BOOL isDraft;
@property (nonatomic, assign, readonly) BOOL isInReview;
@property (nonatomic, assign, readonly) BOOL isPublished;
@property (nonatomic, assign, readonly) BOOL hasAnySteps;
@property (nonatomic, assign, readonly) BOOL hasAnyPublishedComments;

- (void)configureFromDictionary:(NSDictionary *)dictionary includeAuthor:(BOOL)includeAuthor;
- (void)setStateToDraft;
- (void)setStateToInReview;

+ (nonnull Tutorial *)findFirstByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context;

@end
