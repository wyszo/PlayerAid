//
//  PlayerAid
//

@interface ShowImagePickerOverlayWhenOrientationPortraitBehaviour : NSObject

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithImagePickerController:(UIImagePickerController *)imagePickerController;

- (void)activateBehaviour;

@end
