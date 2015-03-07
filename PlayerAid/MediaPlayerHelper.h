//
//  PlayerAid
//

#import <MediaPlayer/MediaPlayer.h>


@interface MediaPlayerHelper : NSObject

+ (void)playVideoWithURL:(NSURL *)url fromViewController:(UIViewController *)viewController;

+ (UIImage *)thumbnailImageFromVideoURL:(NSURL *)videoURL;

@end
