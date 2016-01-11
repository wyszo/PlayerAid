//
//  PlayerAid
//

@import KZAsserts;
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

+ (nonnull UIAlertController *)editDeleteCommentActionControllerWithEditAction:(nonnull VoidBlock)editAction removeAction:(nonnull VoidBlock)removeAction
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  [alertController addAction:[self alertActionWithTitle:@"Edit Comment" action:editAction]];
  [alertController addAction:[self alertActionWithTitle:@"Delete Comment" action:removeAction]];
  [alertController addAction:[self cancelAlertAction]];
  return alertController;
}

+ (UIAlertController *)otherUserCommentActionControllerWithReportCommentAction:(VoidBlock)reportActionBlock visitProfileAction:(VoidBlock)visitProfileAction {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  [alertController addAction:[self alertActionWithTitle:@"Visit Profile" action:visitProfileAction]];
  [alertController addAction:[self alertActionWithTitle:@"Report Comment" action:reportActionBlock]];
  [alertController addAction:[self cancelAlertAction]];
  return alertController;
}

#pragma mark - Private

+ (UIAlertAction *)alertActionWithTitle:(nonnull NSString *)title action:(nonnull VoidBlock)action
{
  AssertTrueOrReturnNil(title.length);
  AssertTrueOrReturnNil(action);
  
  UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull handlerAction) {
    CallBlock(action);
  }];
  return alertAction;
}

+ (UIAlertAction *)cancelAlertAction
{
  return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
}

@end
