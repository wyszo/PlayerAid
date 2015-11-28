//
//  PlayerAid
//

@import Foundation;
@import TWCommonLib;
#import "MakeCommentInputViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface KeyboardCustomAccessoryInputViewHandler : NSObject

@property (nonatomic, copy) VoidBlock inputViewDidDismissBlock;

NEW_AND_INIT_UNAVAILABLE
- (instancetype)initWithAccessoryKeyboardInputViewController:(UIViewController *)viewController desiredInputViewHeight:(CGFloat)inputViewHeight;

- (void)slideInputViewIn;
- (void)slideInputViewOut;

@end

NS_ASSUME_NONNULL_END