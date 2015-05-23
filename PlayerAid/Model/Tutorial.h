#import "_Tutorial.h"


extern NSString *const kTutorialStateUnsaved;
extern NSString *const kTutorialStatePublished;


@interface Tutorial : _Tutorial {}

@property (nonatomic, strong) NSNumber *draft;
@property (nonatomic, strong) NSNumber *inReview;
@property (nonatomic, strong) NSNumber *unsaved;

@end
