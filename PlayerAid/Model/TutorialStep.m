#import "TutorialStep.h"

@interface TutorialStep ()

@end

@implementation TutorialStep

#pragma mark - Initialization

+ (TutorialStep *)tutorialStepWithText:(NSString *)text inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(text.length);
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.text = text;
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(image);
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.imageData = UIImagePNGRepresentation(image);
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(videoUrl);
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.videoPath = videoUrl.absoluteString;
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepInContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(context);
  return [TutorialStep MR_createInContext:context];
}

#pragma mark - Methods

- (UIImage *)image
{
  return [UIImage imageWithData:self.imageData];
}

@end
