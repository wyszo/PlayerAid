//
//  PlayerAid
//


@interface VideoPlayer : NSObject

@property (nonatomic, assign) BOOL presentInLandscapeOrientation;

NEW_AND_INIT_UNAVAILABLE

/**
 * @param parentViewController  usually a navigation controller
 */
- (instancetype)initWithParentViewController:(UIViewController *)parentViewController;

- (void)presentMoviePlayerAndPlayVideoURL:(NSURL *)videoURL;

@end
