//
//  PlayerAid
//

#import <MediaPlayer/MediaPlayer.h>


@interface MediaPlayerHelper : NSObject

/**
 Basic implementation - no error handling, etc
 */
+ (void)playVideoWithURL:(NSURL *)url fromViewController:(UIViewController *)viewController;

+ (UIImage *)thumbnailImageFromVideoURL:(NSURL *)videoURL;

@end
