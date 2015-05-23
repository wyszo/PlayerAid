//
//  PlayerAid
//

#import "ShowImagePickerOverlayWhenOrientationPortraitBehaviour.h"
#import "ImagePickerOverlayController.h"
#import "OrientationChangeDetector.h"
#import "UIView+FadeAnimations.h"
#import "UIImagePickerExtendedEventsObserver.h"


@interface ShowImagePickerOverlayWhenOrientationPortraitBehaviour() <OrientationChangeDelegate, ExtendedUIImagePickerControllerDelegate>

@property (nonatomic, strong) OrientationChangeDetector *orientationChangeDetector;
@property (nonatomic, strong) UIImagePickerExtendedEventsObserver *imagePickerEventsObserver;
@property (nonatomic, strong) ImagePickerOverlayController *imagePickerOverlayController;
@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@end


@implementation ShowImagePickerOverlayWhenOrientationPortraitBehaviour

- (instancetype)initWithImagePickerController:(UIImagePickerController *)imagePickerController
{
  AssertTrueOrReturnNil(imagePickerController);
  if (self = [super init]) {
    _imagePickerController = imagePickerController;
    _imagePickerOverlayController = [[ImagePickerOverlayController alloc] initWithImagePickerController:imagePickerController];
  }
  return self;
}

- (void)activateBehaviour
{
  self.imagePickerEventsObserver = [[UIImagePickerExtendedEventsObserver alloc] initWithDelegate:self];
  [self.orientationChangeDetector startDetectingOrientationChanges];
  [self checkOrientationPresentOverlayForPortrait];
}

#pragma mark - Overlay

- (void)presentPortraitOrientationOverlay
{
  [self.imagePickerOverlayController showOverlay];
}

- (void)hidePortraitOrientationOverlay
{
  [self.imagePickerOverlayController hideOverlay];
}

- (void)checkOrientationPresentOverlayForPortrait
{
  AssertTrueOrReturn(self.orientationChangeDetector);
  if (UIInterfaceOrientationIsPortrait(self.orientationChangeDetector.lastInterfaceOrientation)) {
    [self presentPortraitOrientationOverlay];
  }
}

#pragma mark - ExtendedUIImagePickerControllerDelegate

- (void)imagePickerControllerUserDidCaptureItem
{
  [self.imagePickerOverlayController hideOverlay];
  [self.orientationChangeDetector stopDetectingOrientationChanges];
}

- (void)imagePickerControllerUserDidPressRetake
{
  [self.orientationChangeDetector startDetectingOrientationChanges];
  [self checkOrientationPresentOverlayForPortrait];
}

#pragma mark - orientationChangeDetector

- (void)orientationDidChangeToPortrait
{
  [self presentPortraitOrientationOverlay];
}

- (void)orientationDidChangeToLandscape
{
  [self hidePortraitOrientationOverlay];
}

#pragma mark - Lazy initialization

- (OrientationChangeDetector *)orientationChangeDetector
{
  if (!_orientationChangeDetector) {
    _orientationChangeDetector = [OrientationChangeDetector new];
    _orientationChangeDetector.delegate = self;
  }
  return _orientationChangeDetector;
}

@end
