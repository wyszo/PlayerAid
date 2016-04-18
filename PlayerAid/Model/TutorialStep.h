#import "_TutorialStep.h"
@import UIKit;
@import CoreData;
#import <TWCommonLib/TWConfigurableFromDictionary.h>
#import <TWCommonLib/TWCommonTypes.h>

@interface TutorialStep : _TutorialStep <TWConfigurableFromDictionary>

+ (TutorialStep *)tutorialStepWithText:(NSString *)text inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context;
+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context;

- (void)placeImageInImageView:(UIImageView *)imageView;
- (void)placeImageInImageView:(UIImageView *)imageView completion:(BlockWithBoolParameter)completion;
- (UIImage *)thumbnailImage;

- (BOOL)isTextStep;
- (BOOL)isImageStep;
- (BOOL)isVideoStep;

#pragma mark - Class methods

+ (nullable NSNumber *)serverIDFromTutorialStepDictionary:(nonnull NSDictionary *)dictionary;
+ (nonnull TutorialStep *)findFirstOrCreateByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context;

@end
