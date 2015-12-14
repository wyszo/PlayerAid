//
//  PlayerAid
//

@import TWCommonLib;
@import UIKit;

/**
 The purpose of this class is to encapsulate methods that limit MakeComment and EditComment Input TextView line count and set scrollEnabled to YES if line count exceeded.
 When making changes, remember that both make and edit comment bars use this logic, test both.
 */
@interface LimitInputTextViewLineCountBehaviour : NSObject

NEW_AND_INIT_UNAVAILABLE
- (nonnull instancetype)initWithInputTextView:(nonnull UITextView *)inputTextView;

- (void)updateTextViewSizeAndScrollEnabled;
- (CGFloat)constrainedComputedTextViewHeight;

// Technical debt: poor man's delegate proxy - required for limiting allowed characters count
- (BOOL)textView:(nonnull UITextView *)textView shouldChangeTextInRange:(NSRange)textToReplaceRange replacementText:(nullable NSString *)replacementText;

@end
