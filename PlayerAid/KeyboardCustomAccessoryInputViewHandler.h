//
//  PlayerAid
//

@import Foundation;
@import TWCommonLib;
#import "MakeCommentInputViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface KeyboardCustomAccessoryInputViewHandler : NSObject

NEW_AND_INIT_UNAVAILABLE
- (instancetype)initWithAccessoryKeyboardInputViewController:(UIViewController *)viewController;

- (void)slideInputViewIn;
- (void)slideInputViewOut;

@end

NS_ASSUME_NONNULL_END