//
//  PlayerAid
//

#import "CameraPortraitBlockingOverlayViewController.h"
#import <TWCommonLib/TWCommonMacros.h>

static NSString *const kOverlayNibName = @"CameraPortraitBlockingOverlay";

@implementation CameraPortraitBlockingOverlayViewController

- (instancetype)init
{
  self = [super initWithNibName:kOverlayNibName bundle:nil];
  if (self) {
  }
  return self;
}

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(id)sender
{
  CallBlock(self.didPressCancelBlock);
}

@end
