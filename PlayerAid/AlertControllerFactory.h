//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import <TWCommonLib/TWCommonTypes.h>

@interface AlertControllerFactory : NSObject

+ (UIAlertController *)editProfilePhotoActionControllerFacebookAction:(VoidBlock)facebookAction chooseFromLibraryAction:(VoidBlock)chooseFromLibraryAction takePhotoAction:(VoidBlock)takePhotoAction;

@end
