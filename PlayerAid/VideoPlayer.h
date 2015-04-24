//
//  PlayerAid
//


@interface VideoPlayer : NSObject

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

/**
 * @param parentViewController  usually a navigation controller
 */
- (instancetype)initWithParentViewController:(UIViewController *)parentViewController;

- (void)presentMoviePlayerAndPlayVideoURL:(NSURL *)videoURL;

@end
