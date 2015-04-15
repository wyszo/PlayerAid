//
//  PlayerAid
//

@protocol OrientationHelperDelegate;


@interface OrientationChangeHelper : NSObject

@property (nonatomic, weak) id<OrientationHelperDelegate> delegate;

@property (nonatomic, assign, readonly) UIInterfaceOrientation lastInterfaceOrientation;

- (void)startDetectingOrientationChanges;
- (void)stopDetectingOrientationChanges;

@end


@protocol OrientationHelperDelegate <NSObject>

- (void)orientationDidChangeToPortrait;
- (void)orientationDidChangeToLandscape;

@end
