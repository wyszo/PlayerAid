#import "_Tutorial.h"


extern NSString *const kTutorialStateUnsaved;
extern NSString *const kTutorialStatePublished;

extern NSString *const kTutorialDictionaryServerIDPropertyName;



@interface Tutorial : _Tutorial {}

@property (nonatomic, strong) NSNumber *draft;
@property (nonatomic, strong) NSNumber *inReview;
@property (nonatomic, strong) NSNumber *unsaved;

- (void)configureFromDictionary:(NSDictionary *)dictionary;

@end
