//
//  PlayerAid
//

@import TWCommonLib;
#import "AlertControllerFactory.h"

@implementation AlertControllerFactory

#pragma mark - Interface

+ (UIAlertController *)editProfilePhotoActionControllerFacebookAction:(nullable VoidBlock)facebookAction chooseFromLibraryAction:(nullable VoidBlock)chooseFromLibraryAction takePhotoAction:(nullable VoidBlock)takePhotoAction
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

  if (facebookAction) {
    UIAlertAction *facebookAlertAction = [UIAlertAction actionWithTitle:@"Update from Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      CallBlock(facebookAction);
    }];
    [alertController addAction:facebookAlertAction];
  }

  if (chooseFromLibraryAction) {
    UIAlertAction *libraryAlertAction = [UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      CallBlock(chooseFromLibraryAction);
    }];
    [alertController addAction:libraryAlertAction];
  }

  if (takePhotoAction) {
    UIAlertAction *takePhotoAlertAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      CallBlock(takePhotoAction);
    }];
    [alertController addAction:takePhotoAlertAction];
  }
  
  [alertController addAction:[self cancelAlertAction]];
  return alertController;
}

+ (UIAlertController *)reportCommentActionControllerWithAction:(VoidBlock)reportActionBlock
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"Report Comment" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    CallBlock(reportActionBlock);
  }];
  [alertController addAction:reportAction];
  
  [alertController addAction:[self cancelAlertAction]];
  return alertController;
}

#pragma mark - Private

+ (UIAlertAction *)cancelAlertAction
{
  return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
}

@end
