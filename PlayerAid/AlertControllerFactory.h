//
//  PlayerAid
//

@interface AlertControllerFactory : NSObject

+ (UIAlertController *)editProfilePhotoActionControllerFacebookAction:(VoidBlock)facebookAction chooseFromLibraryAction:(VoidBlock)chooseFromLibraryAction takePhotoAction:(VoidBlock)takePhotoAction;

@end
