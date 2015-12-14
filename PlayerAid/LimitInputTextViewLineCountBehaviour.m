//
//  PlayerAid
//

@import KZAsserts;
#import "LimitInputTextViewLineCountBehaviour.h"

static const CGFloat kMaxAllowedMakeCommentTextViewHeight = 130.0f; // 7 lines, technical debt: should be calculated programmatically
static const CGFloat kOnelineHeightConstraintValue = 30.0f; // Technical debt: we don't wanna hardcode that!

static const NSUInteger kMaxInputTextViewCharactersCount = 5000; // should this really be that much?

@interface LimitInputTextViewLineCountBehaviour ()
@property (nonatomic, strong) UITextView *inputTextView;
@end

@implementation LimitInputTextViewLineCountBehaviour

- (nonnull instancetype)initWithInputTextView:(nonnull UITextView *)inputTextView
{
  AssertTrueOrReturnNil(inputTextView);
  self = [super init];
  if (self) {
    _inputTextView = inputTextView;
  }
  return self;
}

#pragma mark - Public

- (void)updateTextViewSizeAndScrollEnabled
{
  [self updateTextViewScrolling];
  self.inputTextView.tw_height = [self constrainedComputedTextViewHeight];
}

- (CGFloat)constrainedComputedTextViewHeight
{
  if (!self.inputTextView.isFirstResponder) {
    return kOnelineHeightConstraintValue; // technical debt, this should definitely not be hardcoded
  }
  return MIN([self unconstrainedComputedTextViewHeight], kMaxAllowedMakeCommentTextViewHeight);
}

#pragma mark - UITextViewDelegate routed methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)textToReplaceRange replacementText:(NSString *)replacementText
{
  AssertTrueOrReturnNo(textView == self.inputTextView);
  return (textView.text.length + (replacementText.length - textToReplaceRange.length) <= kMaxInputTextViewCharactersCount);
}

#pragma mark - Private

- (void)updateTextViewScrolling
{
  if (!self.inputTextView.isFirstResponder) {
    [self.inputTextView scrollsToTop];
  }
  self.inputTextView.scrollEnabled = [self shouldEnableTextViewScrolling];
}

- (CGFloat)unconstrainedComputedTextViewHeight
{
  return [self.inputTextView sizeThatFits:self.inputTextView.frame.size].height;
}

- (BOOL)shouldEnableTextViewScrolling
{
  if (!self.inputTextView.isFirstResponder) {
    return NO;
  }
  return ([self unconstrainedComputedTextViewHeight] >= kMaxAllowedMakeCommentTextViewHeight);
}

@end