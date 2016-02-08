//
//  PlayerAid
//

@import UIKit;
@import TWCommonLib;
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface MakeCommentInputViewController : UIViewController

/**
 @param   completion  Completion block has bool parameter determining if post a comment was successful (if it is, textView is gonna get cleared
 */
@property (nonatomic, copy) void (^postButtonPressedBlock)(NSString *text, BlockWithBoolParameter completion);

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithUser:(User *)user;

- (BOOL)isInputTextViewFirstResponder;
- (void)hideKeyboard;
- (void)setCustomPlaceholder:(NSString *)placeholder;
- (void)clearInputTextView;

@end

NS_ASSUME_NONNULL_END