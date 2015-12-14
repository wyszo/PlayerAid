//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "EditCommentInputViewController.h"
#import "ColorsHelper.h"
#import "TutorialComment.h"
#import "LimitInputTextViewLineCountBehaviour.h"

static NSString *const kNibName = @"EditCommentInputView";

@interface EditCommentInputViewController () <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *inputTextView;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, copy) NSString *originalText;
@property (strong, nonatomic) LimitInputTextViewLineCountBehaviour *limitInputTextViewLineCountBehaviour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextViewTopMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextViewBottomMarginConstraint;
@end

@implementation EditCommentInputViewController

#pragma mark - Init

- (instancetype)init
{
  self = [super initWithNibName:kNibName bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.limitInputTextViewLineCountBehaviour = [[LimitInputTextViewLineCountBehaviour alloc] initWithInputTextView:self.inputTextView];
  self.inputTextView.delegate = self;
  [self styleView];
  [self updateSaveButtonHighlight];
}

- (void)styleView
{
  self.inputTextView.textColor = [ColorsHelper makeCommentInputTextViewTextColor];
  
  [self.view tw_addTopBorderWithWidth:0.5f color:[ColorsHelper makeEditCommentInputViewTopBorderColor]];
  [self.inputTextView tw_addBorderWithWidth:0.5f color:[ColorsHelper editedCommentKeyboardInputViewInputTextViewBorderColor]];
  
  [self.saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

#pragma mark - Dismissing keyboard

- (void)willMoveToParentViewController:(UIViewController *)parent
{
  [super willMoveToParentViewController:parent];
  if (parent == nil) {
    [self.inputTextView resignFirstResponder]; // dismiss keyboard when dismissing TutorialDetails view (if it's open)
  }
}

#pragma mark - InputTextView sizing

- (void)updateTextViewSizeAndAdjustWholeViewSize
{
  [self.limitInputTextViewLineCountBehaviour updateTextViewSizeAndScrollEnabled];
  [self adjustWholeViewSizeToTextViewSize];
}

- (void)adjustWholeViewSizeToTextViewSize
{
  CGFloat viewBottom = self.view.tw_bottom;
  
  CGFloat computedViewHeight = ([self.limitInputTextViewLineCountBehaviour constrainedComputedTextViewHeight] + [self topBottomInputViewMarginConstraints]);
  self.view.tw_height = computedViewHeight;
  self.view.tw_bottom = viewBottom;
}

- (CGFloat)topBottomInputViewMarginConstraints
{
  AssertTrueOr(self.inputTextViewTopMarginConstraint,);
  AssertTrueOr(self.inputTextViewBottomMarginConstraint,);
  return (self.inputTextViewTopMarginConstraint.constant + self.inputTextViewBottomMarginConstraint.constant);
}

#pragma mark - Public

- (void)setComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  _comment = comment;
  
  self.originalText = comment.text;
  self.inputTextView.text = comment.text;
  [self.inputTextView becomeFirstResponder]; // required for correct sizing
  [self updateTextViewSizeAndAdjustWholeViewSize];
}

- (void)setInputViewToFirstResponder
{
  [self.inputTextView becomeFirstResponder];
}

- (void)hideKeyboard
{
  [self.inputTextView resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(id)sender
{
  CallBlock(self.cancelButtonAction);
}

- (IBAction)saveButtonPressed:(id)sender
{
  CallBlock(self.saveButtonAction, self.trimmedCommentText);
}

#pragma mark - private

- (NSString *)trimmedCommentText
{
  return [self.inputTextView.text tw_stringByTrimmingWhitespaceAndNewline];
}

- (void)updateSaveButtonHighlight
{
  BOOL textNotEmpty = (self.trimmedCommentText.length > 0);
  BOOL textChanged = !([self.trimmedCommentText isEqualToString:self.originalText]);
  
  self.saveButton.enabled = (textNotEmpty && textChanged);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView * _Nonnull)textView
{
  AssertTrueOrReturn(textView == self.inputTextView);
  [self updateTextViewSizeAndAdjustWholeViewSize];
  [self updateSaveButtonHighlight];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)textToReplaceRange replacementText:(NSString *)replacementText
{
  return [self.limitInputTextViewLineCountBehaviour textView:textView shouldChangeTextInRange:textToReplaceRange replacementText:replacementText];
}

@end
