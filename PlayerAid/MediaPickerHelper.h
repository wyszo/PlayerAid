//
//  PlayerAid
//

#import "FDTakeController+WhiteStatusbar.h"


@interface MediaPickerHelper : NSObject

+ (FDTakeController *)fdTakeControllerWithDelegate:(id <FDTakeDelegate>)delegate viewControllerForPresentingImagePickerController:(UIViewController *)viewController;

@end
