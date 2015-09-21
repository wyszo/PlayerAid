//
//  PlayerAid
//

#import <YCameraView/YCameraViewController.h>
#import "FDTakeController+WhiteStatusbar.h"


@interface MediaPickerHelper : NSObject

+ (FDTakeController *)fdTakeControllerWithDelegate:(id <FDTakeDelegate>)delegate viewControllerForPresentingImagePickerController:(UIViewController *)viewController;

+ (void)takePictureUsingYCameraViewWithDelegate:(id<YCameraViewControllerDelegate>)delegate fromViewController:(UIViewController *)parentViewController;

@end
