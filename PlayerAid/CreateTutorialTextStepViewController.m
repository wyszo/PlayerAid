//
//  PlayerAid
//

@import TWCommonLib;
@import NSString_RemoveEmoji;
#import "CreateTutorialTextStepViewController.h"
#import "AlertFactory.h"
#import "GlobalSettings.h"

/**
 Technical debt: this class should use TWTextViewWithCharacterLimitLabelDelegate instead of implementing it from scratch. See EditProfileView as an example. 
 */

NSString *const kCreateTutorialErrorDomain = @"CreateTutorialDomain";
const NSInteger kTextStepDismissedError = 1;


@interface CreateTutorialTextStepViewController () <UITextViewDelegate>

@property (copy, nonatomic) CreateTextStepCompletion completionBlock;
@property (strong, nonatomic) TutorialStep *tutorialTextStep;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *characterLimitLabel;
@property (weak, nonatomic) UIBarButtonItem *confirmNavbarButton;
@property (assign, nonatomic) NSInteger remainingCharactersCount;

@end


@implementation CreateTutorialTextStepViewController

#pragma mark - Initialization

- (instancetype)initWithCompletion:(CreateTextStepCompletion)completionBlock
{
  return [self initWithCompletion:completionBlock tutorialTextStep:nil];
}

- (instancetype)initWithCompletion:(CreateTextStepCompletion)completionBlock tutorialTextStep:(TutorialStep *)tutorialStep
{
  self = [super initWithNibName:@"CreateTutorialTextStepView" bundle:nil];
  if (self) {
    _completionBlock = completionBlock;
    _tutorialTextStep = tutorialStep;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self customizeNavigationBarButtons];
  [self.textView becomeFirstResponder];
  
  [self tw_setNavbarDoesNotCoverTheView];
  [self setupCharactersCount];
  self.textView.keyboardType = UIKeyboardTypeASCIICapable;
  
  [self prepopulateTextViewText];
  [self installSwipeRightGestureRecognizer];
  [self updateTextStepRemainingCharactersCount];
  [self updateConfirmButtonState];
}

- (void)prepopulateTextViewText
{
  if (self.tutorialTextStep) {
    self.textView.text = self.tutorialTextStep.text;
  }
}

- (void)installSwipeRightGestureRecognizer
{
  UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
  gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)swipeGestureRecognizer:(id)sender
{
  [self dismissViewControllerShowingConfirmationAlertIfNeeded];
}

- (void)setupCharactersCount
{
  self.textView.delegate = self;
  [self updateCharactersCountLabel];
}

- (void)customizeNavigationBarButtons
{
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  
  UIBarButtonItem *confirmNavbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(addTextButtonPressed)];
  self.navigationItem.rightBarButtonItem = confirmNavbarButton;
  self.confirmNavbarButton = confirmNavbarButton;
}

- (void)updateCharactersCountLabel
{
  self.characterLimitLabel.text = [NSString stringWithFormat:@"%ld", (long)self.remainingCharactersCount];
  
  UIColor *labelColor;
  if ([self overCharacterLimit]) {
    labelColor = [UIColor redColor];
  } else {
    labelColor = [UIColor grayColor];
  }
  self.characterLimitLabel.textColor = labelColor;
}

- (void)updateConfirmButtonState
{
  self.confirmNavbarButton.enabled = !([self overCharacterLimit]) && (self.processedText.length > 0);
}

- (void)updateTextColor
{
  UIColor *textColor;
  if ([self overCharacterLimit]) {
    textColor = [UIColor redColor];
  } else {
    textColor = [UIColor blackColor];
  }
  
  if (self.textView.textColor != textColor) {
    self.textView.textColor = textColor;
  }
}

- (BOOL)overCharacterLimit
{
  return (self.remainingCharactersCount < 0);
}

#pragma mark - Text transformation

- (NSString *)processedText
{
  return [self.textView.text tw_stringByTrimmingWhitespaceAndNewline];
}

#pragma UITextViewDelegate

- (void)updateTextStepRemainingCharactersCount
{
  [self textViewDidChange:self.textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
  self.remainingCharactersCount = (kMaxTextStepCharactersCount - textView.text.length);
  [self updateCharactersCountLabel];
  [self updateConfirmButtonState];
  [self updateTextColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if (text.isIncludingEmoji) {
    return NO;
  }
  return YES;
}

#pragma mark - Actions

- (void)addTextButtonPressed
{
  [self popViewController];
  CallBlock(self.completionBlock, self.processedText, nil);
}

- (void)cancelButtonPressed
{
  [self dismissViewControllerShowingConfirmationAlertIfNeeded];
}

- (void)dismissViewControllerShowingConfirmationAlertIfNeeded
{
  [self.textView resignFirstResponder];
  
  if (!self.processedText.length) {
    [self forceDismissViewControllerWithError];
    return;
  }
  
  defineWeakSelf();
  void (^confirmationAlertCompletionBlock)(BOOL) = ^(BOOL discard) {
    if (discard) {
      [weakSelf forceDismissViewControllerWithError];
    }
  };
  
  if ([self isEditingExistingTutorialTextStep]) {
    [AlertFactory showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion:confirmationAlertCompletionBlock];
  }
  else {
    [AlertFactory showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:confirmationAlertCompletionBlock];
  }
}

- (BOOL)isEditingExistingTutorialTextStep
{
  return (self.tutorialTextStep != nil);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self deselectAllText];
}

#pragma mark - Auxiliary methods

- (void)deselectAllText
{
  self.textView.selectedTextRange = nil;
}

- (void)forceDismissViewControllerWithError
{
  [self popViewController];
  
  NSError *error = [NSError errorWithDomain:kCreateTutorialErrorDomain code:kTextStepDismissedError userInfo:nil];
  CallBlock(self.completionBlock, nil, error);
}

- (void)popViewController
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
