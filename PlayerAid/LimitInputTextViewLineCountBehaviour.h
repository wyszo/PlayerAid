//
//  PlayerAid
//

@import TWCommonLib;
@import UIKit;

/**
 The purpose of this class is to encapsulate methods that limit MakeComment Input TextView line count and set scrollEnabled to YES if line count exceeded
 */
@interface LimitInputTextViewLineCountBehaviour : NSObject

NEW_AND_INIT_UNAVAILABLE
- (nonnull instancetype)initWithInputTextView:(nonnull UITextView *)inputTextView;

- (void)updateTextViewSizeAndScrollEnabled;
- (CGFloat)constrainedComputedTextViewHeight;

@end
