#import "_TutorialStep.h"

@interface TutorialStep : _TutorialStep {}

+ (TutorialStep *)tutorialStepWithText:(NSString *)text inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context;

- (UIImage *)image;

- (BOOL)isTextStep;
- (BOOL)isImageStep;
- (BOOL)isVideoStep;

@end
