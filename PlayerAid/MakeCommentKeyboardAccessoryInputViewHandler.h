//
//  PlayerAid
//

@import Foundation;
#import "MakeCommentInputViewController.h"

@interface MakeCommentKeyboardAccessoryInputViewHandler : NSObject

@property (nonatomic, strong, readonly) MakeCommentInputViewController *makeCommentInputViewController;

- (void)slideInputViewIn;
- (void)slideInputViewOut;

@end
