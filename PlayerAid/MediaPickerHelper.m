//
//  PlayerAid
//

#import "MediaPickerHelper.h"


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

@end
