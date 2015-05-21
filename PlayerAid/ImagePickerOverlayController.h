//
//  PlayerAid
//


@interface ImagePickerOverlayController : NSObject

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithImagePickerController:(UIImagePickerController *)imagePickerController;

- (void)showOverlay;
- (void)hideOverlay;

@end
