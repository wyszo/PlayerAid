//
//  PlayerAid
//

@import KZAsserts;
#import "LimitInputTextViewLineCountBehaviour.h"

static const CGFloat kMaxAllowedMakeCommentTextViewHeight = 130.0f; // 7 lines, technical debt: should be calculated programmatically

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
  self.inputTextView.tw_height = [self constrainedComputedTextViewHeight];
  self.inputTextView.scrollEnabled = [self shouldEnableTextViewScrolling];
}

- (CGFloat)constrainedComputedTextViewHeight
{
  return MIN([self unconstrainedComputedTextViewHeight], kMaxAllowedMakeCommentTextViewHeight);
}

#pragma mark - Private

- (CGFloat)unconstrainedComputedTextViewHeight
{
  return [self.inputTextView sizeThatFits:self.inputTextView.frame.size].height;
}

- (BOOL)shouldEnableTextViewScrolling
{
  return ([self unconstrainedComputedTextViewHeight] >= kMaxAllowedMakeCommentTextViewHeight);
}

@end