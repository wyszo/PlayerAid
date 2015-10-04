//
//  PlayerAid
//

@import UIKit;
@import Foundation;
@import MediaPlayer;

@interface MediaPlayerHelper : NSObject

/**
 Basic implementation - no error handling, etc
 */
+ (void)playVideoWithURL:(NSURL *)url fromViewController:(UIViewController *)viewController;

@end
