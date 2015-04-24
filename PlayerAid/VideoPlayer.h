//
//  PlayerAid
//


@interface VideoPlayer : NSObject

@property (nonatomic, assign) BOOL presentInLandscapeOrientation;

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

/**
 * @param parentViewController  usually a navigation controller
 */
- (instancetype)initWithParentViewController:(UIViewController *)parentViewController;

- (void)presentMoviePlayerAndPlayVideoURL:(NSURL *)videoURL;

@end
