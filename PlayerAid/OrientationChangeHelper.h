//
//  PlayerAid
//

@protocol OrientationHelperDelegate;


@interface OrientationChangeHelper : NSObject

@property (nonatomic, weak) id<OrientationHelperDelegate> delegate;

- (void)startDetectingOrientationChanges;
- (void)stopDetectingOrientationChanges;

- (UIInterfaceOrientation)interfaceOrientation;

@end


@protocol OrientationHelperDelegate <NSObject>

- (void)orientationDidChangeToPortrait;
- (void)orientationDidChangeToLandscape;

@end
