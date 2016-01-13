@import Foundation;

extern const CGFloat kKeyboardMakeCommentAccessoryInputViewHeight;

@class MakeCommentInputViewController, KeyboardCustomAccessoryInputViewHandler, EditCommentInputViewController;


@interface KeyboardCustomInputAccessoryViewsManager : NSObject

// TODO: try hiding those properties in the implementation?

// managing those input views needs to be extracted into a separate class, it's starting to get messy around here!

@property (strong, nonatomic) MakeCommentInputViewController *makeCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *makeCommentInputViewHandler;

@property (strong, nonatomic) EditCommentInputViewController *editCommentInputVC;
@property (strong, nonatomic) KeyboardCustomAccessoryInputViewHandler *editCommentInputViewHandler;

@property (nonatomic, copy) void (^makeACommentButtonPressedBlock)(NSString *text, BlockWithBoolParameter completion);

@property (nonatomic, copy) BoolReturningBlock areCommentsExpanded; // required // TODO: enforce this as a requierd property!!

- (void)dismissAllInputViews;
- (void)dismissEditCommentBar;

- (void)setup; // TODO: remove this method!!

- (void)resetState;

- (void)slideOutActiveInputViewIfCommentsExpanded;
- (void)slideInActiveInputViewIfCommentsExpanded;

@end
