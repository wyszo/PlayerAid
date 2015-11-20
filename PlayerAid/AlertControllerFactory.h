//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

@interface AlertControllerFactory : NSObject

+ (UIAlertController *)editProfilePhotoActionControllerFacebookAction:(VoidBlock)facebookAction chooseFromLibraryAction:(VoidBlock)chooseFromLibraryAction takePhotoAction:(VoidBlock)takePhotoAction;

+ (UIAlertController *)reportCommentActionControllerWithAction:(nonnull VoidBlock)reportAction;

@end
