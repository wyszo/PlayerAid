//
//  PlayerAid
//

#import "ImagePickerOverlayController.h"


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
  [self.imagePickerController.cameraOverlayView addSubview:self.overlayViewController.view];
}

- (void)hideOverlay
{
  AssertTrueOrReturn(self.imagePickerController);
  [self.overlayViewController.view removeFromSuperview];
}

- (UIViewController *)overlayViewController
{
  // TODO: read an overlay view interface from xib!
  
  if (!_overlayViewController) {
    _overlayViewController = [[UIViewController alloc] init];
    _overlayViewController.view.backgroundColor = [UIColor blackColor];
    _overlayViewController.view.alpha = 0.7f;
  }
  return _overlayViewController;
}

@end
