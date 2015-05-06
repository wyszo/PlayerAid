//
//  PlayerAid
//

#import "ImagePickerOverlayController.h"
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
  if ([self overlayVisible]) {
    return;
  }
  
  AssertTrueOrReturn(self.imagePickerController);
  [self.overlayViewController.view removeFromSuperview];
  
  [self.overlayViewController.view setFrame:self.imagePickerController.view.frame];
  [self.imagePickerController setCameraOverlayView:self.overlayViewController.view];
  [self.overlayViewController.view tw_fadeInAnimationWithDuration:kOverlayFadeAnimationDuration];
}

- (void)hideOverlay
{
  AssertTrueOrReturn(self.imagePickerController);
  
  defineWeakSelf();
  [self.overlayViewController.view tw_fadeOutAnimationWithDuration:kOverlayFadeAnimationDuration completion:^(BOOL finished) {
    weakSelf.overlayViewController.view.alpha = 0.0f;
    weakSelf.overlayViewController.view.hidden = NO;
    
    weakSelf.imagePickerController.cameraOverlayView = nil;
  }];
}

- (BOOL)overlayVisible
{
  UIView *overlayView = self.overlayViewController.view;
  return (overlayView.superview != nil && overlayView.alpha > 0 && overlayView.hidden == NO);
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
