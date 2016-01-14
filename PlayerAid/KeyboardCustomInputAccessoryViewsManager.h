@import Foundation;
@import TWCommonLib;

extern const CGFloat kKeyboardMakeCommentAccessoryInputViewHeight;

@class MakeCommentInputViewController, KeyboardCustomAccessoryInputViewHandler, EditCommentInputViewController;


@interface KeyboardCustomInputAccessoryViewsManager : NSObject

// TODO: remove those properties from public interface (encapsulate behaviours in necessary methods)

@property (strong, nonatomic, readonly) MakeCommentInputViewController *makeCommentInputVC;
@property (strong, nonatomic, readonly) KeyboardCustomAccessoryInputViewHandler *makeCommentInputViewHandler;

@property (strong, nonatomic, readonly) EditCommentInputViewController *editCommentInputVC;
@property (strong, nonatomic, readonly) KeyboardCustomAccessoryInputViewHandler *editCommentInputViewHandler;

@property (nonatomic, copy) void (^makeACommentButtonPressedBlock)(NSString *text, BlockWithBoolParameter completion);

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithAreCommentsExpandedBlock:(BoolReturningBlock)areCommentsExpandedBlock;

- (void)dismissAllInputViews;
- (void)dismissEditCommentBar;

- (void)slideInActiveInputViewIfCommentsExpanded;
- (void)slideOutActiveInputViewIfCommentsExpanded;

- (void)resetState;

@end
