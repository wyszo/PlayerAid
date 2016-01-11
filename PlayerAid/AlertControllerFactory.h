//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

@interface AlertControllerFactory : NSObject

+ (UIAlertController *)editProfilePhotoActionControllerFacebookAction:(VoidBlock)facebookAction chooseFromLibraryAction:(VoidBlock)chooseFromLibraryAction takePhotoAction:(VoidBlock)takePhotoAction;

+ (nonnull UIAlertController *)editDeleteCommentActionControllerWithEditAction:(nonnull VoidBlock)editAction removeAction:(nonnull VoidBlock)removeAction;

+ (nonnull UIAlertController *)otherUserCommentActionControllerWithReportCommentAction:(VoidBlock)reportAction visitProfileAction:(VoidBlock)visitProfileAction;

@end
