#import "TutorialStep.h"
#import "MediaPlayerHelper.h"
#import "UIImage+TWCropping.h"


static const CGFloat kJPEGCompressionBestQuality = 1.0f;


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
  tutorialStep.imageData = UIImageJPEGRepresentation(image, kJPEGCompressionBestQuality); /** Watch out if ever changing to PNG, PNGs don't retain image rotation data, while JPGs do */
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(videoUrl);
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.videoPath = videoUrl.absoluteString;
  
  UIImage *thumbnailLandscape = [MediaPlayerHelper thumbnailImageFromVideoURL:videoUrl];
  UIImage *thumbnailSquare = [thumbnailLandscape tw_imageByCroppingCenterToSquare];
  AssertTrueOr(thumbnailSquare, ;);
  tutorialStep.videoThumbnailData = UIImageJPEGRepresentation(thumbnailSquare, kJPEGCompressionBestQuality);
  
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

- (UIImage *)thumbnailImage
{
  return [UIImage imageWithData:self.videoThumbnailData];
}

- (BOOL)isTextStep
{
  return (self.text.length != 0);
}

- (BOOL)isImageStep
{
  return (self.imageData != nil);
}

- (BOOL)isVideoStep
{
  return (self.videoPath.length != 0);
}

@end
