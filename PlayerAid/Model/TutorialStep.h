#import "_TutorialStep.h"
@import UIKit;
@import CoreData;
#import <TWCommonLib/TWConfigurableFromDictionary.h>

@interface TutorialStep : _TutorialStep <TWConfigurableFromDictionary>

+ (TutorialStep *)tutorialStepWithText:(NSString *)text inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context;

- (void)placeImageInImageView:(UIImageView *)imageView;
- (UIImage *)thumbnailImage;

- (BOOL)isTextStep;
- (BOOL)isImageStep;
- (BOOL)isVideoStep;

+ (NSNumber *)serverIDFromTutorialStepDictionary:(NSDictionary *)dictionary;

@end
