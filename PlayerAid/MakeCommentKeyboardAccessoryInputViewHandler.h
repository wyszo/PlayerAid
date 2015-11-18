//
//  PlayerAid
//

@import Foundation;
#import "AddCommentInputViewController.h"

@interface MakeCommentKeyboardAccessoryInputViewHandler : NSObject

@property (nonatomic, strong, readonly) AddCommentInputViewController *makeCommentInputViewController;

- (void)slideInputViewIn;
- (void)slideInputViewOut;

@end
