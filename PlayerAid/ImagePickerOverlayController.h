//
//  PlayerAid
//

// TODO: implement ShowImagePickerOverlayWhenOrientationPortraitBehaviour handling instance of this class internally

@interface ImagePickerOverlayController : NSObject

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithImagePickerController:(UIImagePickerController *)imagePickerController;

- (void)showOverlay;
- (void)hideOverlay;

@end
