#import "_TutorialStep.h"

@interface TutorialStep : _TutorialStep <TWConfigurableFromDictionary>

+ (TutorialStep *)tutorialStepWithText:(NSString *)text inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context;

- (UIImage *)image;
- (UIImage *)thumbnailImage;

- (BOOL)isTextStep;
- (BOOL)isImageStep;
- (BOOL)isVideoStep;

+ (NSString *)serverIDFromTutorialStepDictionary:(NSDictionary *)dictionary;

@end
