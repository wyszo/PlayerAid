//
//  PlayerAid
//

#import "InterfaceOrientationClassStubs.h"

#pragma mark - InterfaceOrientationClassStub

@implementation InterfaceOrientationClassStub

- (BOOL)shouldAutorotate
{
  AssertTrueOrReturnNo(0 && @"Base class, empty implementation");
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
  AssertTrueOr((0 && @"Base class, empty implementation"), return 0;);
  return 0;
}

@end

#pragma mark - InterfaceOrientationPortraitStub

@implementation InterfaceOrientationPortraitStub

- (BOOL)shouldAutorotate
{
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}

@end

#pragma mark - InterfaceOrientationAllButUpsideDownStub

@implementation InterfaceOrientationAllButUpsideDownStub

- (BOOL)shouldAutorotate
{
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
