#import "_Tutorial.h"


extern NSString *const kTutorialStateUnsaved;
extern NSString *const kTutorialStatePublished;


@interface Tutorial : _Tutorial {}

@property (nonatomic, strong) NSNumber *draft;
@property (nonatomic, strong) NSNumber *inReview;
@property (nonatomic, strong) NSNumber *unsaved;

// TODO: helper methods, can be extracted from here
+ (Tutorial *)tutorialWithServerID:(NSString *)serverID inContext:(NSManagedObjectContext *)localContext;
+ (NSString *)serverIDFromTutorialDictionary:(NSDictionary *)dictionary;

- (void)configureFromDictionary:(NSDictionary *)dictionary;

@end
