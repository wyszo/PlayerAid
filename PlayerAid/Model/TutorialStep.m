#import "TutorialStep.h"

@interface TutorialStep ()

@end

@implementation TutorialStep

#pragma mark - Initialization

+ (TutorialStep *)tutorialStepWithText:(NSString *)text inContext:(NSManagedObjectContext *)context
{
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.text = text;
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context
{
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.imageData = UIImagePNGRepresentation(image);
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
