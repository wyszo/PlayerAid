//
//  PlayerAid
//

#import "AlertControllerFactory.h"


@implementation AlertControllerFactory

+ (UIAlertController *)editProfilePhotoActionControllerFacebookAction:(VoidBlock)facebookAction chooseFromLibraryAction:(VoidBlock)chooseFromLibraryAction takePhotoAction:(VoidBlock)takePhotoAction
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction *facebookAlertAction = [UIAlertAction actionWithTitle:@"Update from Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    CallBlock(facebookAction);
  }];
  [alertController addAction:facebookAlertAction];

  UIAlertAction *libraryAlertAction = [UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    CallBlock(chooseFromLibraryAction);
  }];
  [alertController addAction:libraryAlertAction];
  
  UIAlertAction *takePhotoAlertAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    CallBlock(takePhotoAction);
  }];
  [alertController addAction:takePhotoAlertAction];
  
  [alertController addAction:[self cancelAlertAction]];
  return alertController;
}

+ (UIAlertAction *)cancelAlertAction
{
  return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
}

@end
