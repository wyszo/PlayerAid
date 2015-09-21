//
//  PlayerAid
//

#import <YCameraView/YCameraViewController.h>
#import "YCameraViewStandardDelegateObject.h"
#import "PersistedUsersProperties.h"


@implementation YCameraViewStandardDelegateObject

- (void)yCameraController:(YCameraViewController *)cameraController didFinishPickingImage:(UIImage *)image
{
  AssertTrueOrReturn(image);
  CallBlock(self.cameraDidFinishPickingImageBlock, image);
}

- (void)yCameraControllerDidCancel:(YCameraViewController *)cameraController
{
  AssertTrueOrReturn(cameraController);
  self.persistedUserProperties.gridEnabled = [cameraController gridEnabled];
}

- (void)yCameraControllerDidSkip:(YCameraViewController *)cameraController
{
  AssertTrueOrReturn(cameraController);
  self.persistedUserProperties.gridEnabled = [cameraController gridEnabled];
}

- (void)yCameraController:(YCameraViewController *)cameraController didToggleGridEnabled:(BOOL)gridEnabled
{
  AssertTrueOrReturn(cameraController);
  self.persistedUserProperties.gridEnabled = [cameraController gridEnabled];
}

- (PersistedUsersProperties *)persistedUserProperties
{
  return [PersistedUsersProperties sharedInstance];
}

@end
