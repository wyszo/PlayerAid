//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "EditCommentInputViewController.h"
#import "ColorsHelper.h"
#import "TutorialComment.h"

static NSString *const kNibName = @"EditCommentInputView";

@interface EditCommentInputViewController () <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *inputTextView;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, copy) NSString *originalText;
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
  
  self.inputTextView.delegate = self;
  [self styleView];
  [self updateSaveButtonHighlight];
}

- (void)styleView
{
  [self.view tw_addTopBorderWithWidth:1.0f color:[ColorsHelper makeEditCommentInputViewTopBorderColor]];
  [self.inputTextView tw_addBorderWithWidth:1.0 color:[ColorsHelper editedCommentKeyboardInputViewInputTextViewBorderColor]];
}

#pragma mark - Public

- (void)setComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  _comment = comment;
  
  self.originalText = comment.text;
  self.inputTextView.text = comment.text;
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
  [self updateSaveButtonHighlight];
}

@end
