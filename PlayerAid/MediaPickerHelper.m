//
//  PlayerAid
//

@import KZAsserts;
#import "MediaPickerHelper.h"
#import "PersistedUsersProperties.h"


@implementation MediaPickerHelper

+ (FDTakeController *)fdTakeControllerWithDelegate:(id <FDTakeDelegate>)delegate viewControllerForPresentingImagePickerController:(UIViewController *)viewController {
  AssertTrueOrReturnNil(delegate);
  AssertTrueOrReturnNil(viewController);
  
  FDTakeController *mediaController = [[FDTakeController alloc] init];
  mediaController.delegate = delegate;
  mediaController.viewControllerForPresentingImagePickerController = viewController;
  
  mediaController.allowsEditingPhoto = YES;
  mediaController.allowsEditingVideo = YES;
  
  return mediaController;
}

+ (void)takePictureUsingYCameraViewWithDelegate:(id<YCameraViewControllerDelegate>)delegate fromViewController:(UIViewController *)parentViewController
{
  AssertTrueOrReturn(delegate);
  AssertTrueOrReturn(parentViewController);
  
  YCameraViewController *controller = [YCameraViewController new];
  controller.prefersStatusBarHidden = YES;
  controller.gridInitiallyHidden = !([PersistedUsersProperties sharedInstance].gridEnabled);
  controller.delegate = delegate;
  [parentViewController presentViewController:controller animated:YES completion:nil];
  
  controller.libraryToggleButton.hidden = YES;
  controller.cancelButton.hidden = YES;
}

@end
