//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWImagePickerOverlayProtocol.h>

@interface ImagePickerOverlayController : NSObject <TWImagePickerOverlayProtocol>

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithImagePickerController:(UIImagePickerController *)imagePickerController;

- (void)showPickerOverlay;
- (void)hidePickerOverlay;

@end
