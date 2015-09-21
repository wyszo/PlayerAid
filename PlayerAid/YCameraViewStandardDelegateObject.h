//
//  PlayerAid
//

#import <YCameraView/YCameraViewController.h>


@interface YCameraViewStandardDelegateObject : NSObject <YCameraViewControllerDelegate>

@property (nonatomic, copy) void (^cameraDidFinishPickingImageBlock)(UIImage *);

@end
