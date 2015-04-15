//
//  PlayerAid
//

#import "OrientationChangeHelper.h"


@implementation OrientationChangeHelper

#pragma mark - Public interface

- (void)startDetectingOrientationChanges
{
  [self registerForOrientationChangeNotification];
}

- (void)stopDetectingOrientationChanges
{
  [self resignFromOrientationChangeNotification];
}

- (UIInterfaceOrientation)interfaceOrientation
{
  return [[UIApplication sharedApplication] statusBarOrientation];
}

#pragma mark - Notification handling

- (void)registerForOrientationChangeNotification
{
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)resignFromOrientationChangeNotification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)dealloc
{
  [self resignFromOrientationChangeNotification];
}

#pragma mark - processing notifications

- (void)orientationChanged:(NSNotification *)notification
{
  UIInterfaceOrientation orientation = [self interfaceOrientation];
  
  if (UIInterfaceOrientationIsPortrait(orientation)) {
    if ([self.delegate respondsToSelector:@selector(orientationDidChangeToPortrait)]) {
      [self.delegate orientationDidChangeToPortrait];
    }
  } else {
    if ([self.delegate respondsToSelector:@selector(orientationDidChangeToLandscape)]) {
      [self.delegate orientationDidChangeToLandscape];
    }
  }
}

@end
