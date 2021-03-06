//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "ImagePickerOverlayController.h"
#import "CameraPortraitBlockingOverlayViewController.h"

static const NSTimeInterval kOverlayFadeAnimationDuration = 0.25f;


@interface ImagePickerOverlayController()

@property (nonatomic, weak) UIImagePickerController* imagePickerController;
@property (nonatomic, strong) CameraPortraitBlockingOverlayViewController *overlayViewController;

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

- (void)showPickerOverlay
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

- (void)hidePickerOverlay
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
    _overlayViewController = [CameraPortraitBlockingOverlayViewController new];
    defineWeakSelf();
    _overlayViewController.didPressCancelBlock = ^() {
      id<UIImagePickerControllerDelegate> imagePickerDelegate = weakSelf.imagePickerController.delegate;
      [weakSelf.imagePickerController dismissViewControllerAnimated:YES completion:^{
        [imagePickerDelegate imagePickerControllerDidCancel:weakSelf.imagePickerController];
      }];
    };
  }
  return _overlayViewController;
}

@end
