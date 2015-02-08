#import "_Tutorial.h"

extern NSString *const kTutorialStatePublished;


@interface Tutorial : _Tutorial {}

@property (nonatomic, strong) NSNumber *draft;
@property (nonatomic, strong) NSNumber *inReview;

@end
