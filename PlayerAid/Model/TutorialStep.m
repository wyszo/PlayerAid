#import "TutorialStep.h"
@import KZAsserts;
@import AFNetworking;
@import KZPropertyMapper;
@import TWCommonLib;
@import MagicalRecord;
#import "GlobalSettings.h"
#import "MediaPlayerHelper.h"
#import "UIImage+TWCropping.h"
#import "UIImageView+AFNetworkingImageView.h"

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
  tutorialStep.imageData = UIImageJPEGRepresentation(image, kJPEGCompressionQuality); /** Watch out if ever changing to PNG, PNGs don't retain image rotation data, while JPGs do */
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepWithVideoURL:(NSURL *)videoUrl inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(context);
  AssertTrueOrReturnNil(videoUrl);
  
  TutorialStep *tutorialStep = [self tutorialStepInContext:context];
  tutorialStep.videoPath = videoUrl.absoluteString;
  
  UIImage *thumbnailLandscape = [TWVideoThumbnailHelper thumbnailImageFromVideoURL:videoUrl atTimeInSeconds:0];
  UIImage *thumbnailSquare = [thumbnailLandscape tw_imageByCroppingCenterToSquare];
  AssertTrueOr(thumbnailSquare, ;);
  tutorialStep.videoThumbnailData = UIImageJPEGRepresentation(thumbnailSquare, kJPEGCompressionQuality);
  
  return tutorialStep;
}

+ (TutorialStep *)tutorialStepInContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(context);
  return [TutorialStep MR_createEntityInContext:context];
}

#pragma mark - Configuration

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary);
  
  NSMutableDictionary *mapping = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   kTutorialStepServerIDAttributeName : KZProperty(serverID),
                                                                                   @"position" : KZProperty(order),
                                                                                   @"thumbnail" : KZProperty(serverVideoThumbnailUrl),
                                                                                   @"videoLength" : KZProperty(videoLength)
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
  
  AssertTrueOrReturn(self.serverID);
}

#pragma mark - Methods

- (void)placeImageInImageView:(UIImageView *)imageView {
  [self placeImageInImageView:imageView completion:nil];
}

- (void)placeImageInImageView:(UIImageView *)imageView completion:(BlockWithBoolParameter)completion
{
  AssertTrueOrReturn(imageView);
  AssertTrueOrReturn(self.imageData || self.imagePath.length);
  
  UIImage *image = [UIImage imageWithData:self.imageData];
  NSURL *imageUrl = [NSURL URLWithString:self.imagePath];
  AssertTrueOrReturn(image || imageUrl);
  
  if (image) {
    imageView.image = image;
    CallBlock(completion, YES);
  }
  else if (imageUrl) {
    [imageView setImageWithURL:imageUrl completion:completion];
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

+ (nullable NSNumber *)serverIDFromTutorialStepDictionary:(nonnull NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary);
  NSNumber *serverID = dictionary[kTutorialStepServerIDAttributeName];
  AssertTrueOrReturnNil(serverID);
  return serverID;
}

+ (nonnull TutorialStep *)findFirstOrCreateByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context
{
  return [TutorialStep MR_findFirstOrCreateByAttribute:@"serverID" withValue:serverID inContext:context];
}

@end
