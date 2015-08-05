#import "TutorialStep.h"
#import <UIImageView+AFNetworking.h>
#import "MediaPlayerHelper.h"
#import "UIImage+TWCropping.h"
#import "KZPropertyMapper.h"


static const CGFloat kJPEGCompressionBestQuality = 1.0f;
static NSString *const kTutorialStepServerIDAttributeName = @"id";
static NSString *const kTutorialStepDictionaryTypeAttribute = @"type";
static NSString *const kTutorialStepTypeText = @"Text";
static NSString *const kTutorialStepTypeImage = @"Image";
static NSString *const kTutorialStepTypeVideo = @"Video";

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
  
  UIImage *thumbnailLandscape = [TWVideoThumbnailHelper thumbnailImageFromVideoURL:videoUrl atTimeInSeconds:0];
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

#pragma mark - Configuration

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary);
  
  NSMutableDictionary *mapping = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"id" : KZProperty(serverID),
                                                                                   @"position" : KZProperty(order),
                                                                                   @"thumbnail" : KZProperty(serverVideoThumbnailUrl)
                                                                                  }];
  
  if ([dictionary[kTutorialStepDictionaryTypeAttribute] isEqualToString:kTutorialStepTypeText]) {
    [mapping addEntriesFromDictionary:@{ @"data" : KZProperty(text) }];
  }
  if ([dictionary[kTutorialStepDictionaryTypeAttribute] isEqualToString:kTutorialStepTypeImage]) {
    [mapping addEntriesFromDictionary:@{ @"data" : KZProperty(imagePath) }];
  }
  if ([dictionary[kTutorialStepDictionaryTypeAttribute] isEqualToString:kTutorialStepTypeVideo]) {
    [mapping addEntriesFromDictionary:@{ @"data" : KZProperty(videoPath) }];
  }
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
}

#pragma mark - Methods

- (void)placeImageInImageView:(UIImageView *)imageView
{
  AssertTrueOrReturn(imageView);
  AssertTrueOrReturn(self.imageData || self.imagePath.length);
  
  UIImage *image = [UIImage imageWithData:self.imageData];
  NSURL *imageUrl = [NSURL URLWithString:self.imagePath];
  AssertTrueOrReturn(image || imageUrl);
  
  if (image) {
    imageView.image = image;
  }
  else if (imageUrl) {
    [imageView setImageWithURL:imageUrl];
  }
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
  return (self.imageData != nil || self.imagePath.length);
}

- (BOOL)isVideoStep
{
  return (self.videoPath.length != 0);
}

#pragma mark - Class methods

+ (NSString *)serverIDFromTutorialStepDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary);
  NSString *serverID = dictionary[kTutorialStepServerIDAttributeName];
  AssertTrueOrReturnNil(serverID);
  return serverID;
}

@end
