//
//  PlayerAid
//

#import "ImagePickerOverlayController.h"
#import "OrientationChangeDetector.h"
#import "UIView+FadeAnimations.h"
#import "UIImagePickerExtendedEventsObserver.h"


static const NSTimeInterval kOverlayFadeAnimationDuration = 0.25f;


@interface ImagePickerOverlayController()

@property (nonatomic, weak) UIImagePickerController* imagePickerController;
@property (nonatomic, strong) UIViewController *overlayViewController;

@end


@implementation ImagePickerOverlayController

- (instancetype)initWithImagePickerController:(UIImagePickerController *)imagePickerController
{
  AssertTrueOrReturnNil(imagePickerController);
  if (self = [super init]) {
    _imagePickerController = imagePickerController;
  }
  return self;
}

- (void)showOverlay
{
  AssertTrueOrReturn(self.imagePickerController);
  [self.overlayViewController.view removeFromSuperview];
  
  [self.overlayViewController.view setFrame:self.imagePickerController.view.frame];
  [self.imagePickerController setCameraOverlayView:self.overlayViewController.view];
  [self.overlayViewController.view fadeInAnimationWithDuration:kOverlayFadeAnimationDuration];
}

- (void)hideOverlay
{
  AssertTrueOrReturn(self.imagePickerController);
  
  defineWeakSelf();
  [self.overlayViewController.view fadeOutAnimationWithDuration:kOverlayFadeAnimationDuration completion:^(BOOL finished) {
    weakSelf.overlayViewController.view.alpha = 0.0f;
    weakSelf.overlayViewController.view.hidden = NO;
    
    weakSelf.imagePickerController.cameraOverlayView = nil;
  }];
}

#pragma mark - Lazy initialization

- (UIViewController *)overlayViewController
{
  if (!_overlayViewController) {
    _overlayViewController = [[UIViewController alloc] initWithNibName:@"CameraPortraitBlockingOverlay" bundle:nil];
  }
  return _overlayViewController;
}

@end
