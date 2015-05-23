//
//  PlayerAid
//

@protocol OrientationChangeDelegate;


@interface OrientationChangeDetector : NSObject

@property (nonatomic, weak) id<OrientationChangeDelegate> delegate;

@property (nonatomic, assign, readonly) UIInterfaceOrientation lastInterfaceOrientation;

- (void)startDetectingOrientationChanges;
- (void)stopDetectingOrientationChanges;

@end


@protocol OrientationChangeDelegate <NSObject>

- (void)orientationDidChangeToPortrait;
- (void)orientationDidChangeToLandscape;

@end
