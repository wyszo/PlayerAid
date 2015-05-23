//
//  PlayerAid
//

#import "FDTakeController+WhiteStatusbar.h"
#import <YCameraViewController.h>


@interface MediaPickerHelper : NSObject

+ (FDTakeController *)fdTakeControllerWithDelegate:(id <FDTakeDelegate>)delegate viewControllerForPresentingImagePickerController:(UIViewController *)viewController;

+ (void)takePictureUsingYCameraViewWithDelegate:(id<YCameraViewControllerDelegate>)delegate fromViewController:(UIViewController *)parentViewController;

@end
