//
//  PlayerAid
//

@interface InterfaceOrientationClassStub : NSObject
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end


@interface InterfaceOrientationPortraitStub : InterfaceOrientationClassStub
@end


@interface InterfaceOrientationAllButUpsideDownStub  : InterfaceOrientationClassStub
@end
