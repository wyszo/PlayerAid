//
//  PlayerAid
//

#import "CreateTutorialTextStepViewController.h"
#import <NSString+RemoveEmoji.h>
#import "AlertFactory.h"
#import "NSString+Trimming.h"
#import "GlobalSettings.h"


NSString *const kCreateTutorialErrorDomain = @"CreateTutorialDomain";
const NSInteger kTextStepDismissedError = 1;


@interface CreateTutorialTextStepViewController () <UITextViewDelegate>

@property (copy, nonatomic) CreateTextStepCompletion completionBlock;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *characterLimitLabel;
@property (weak, nonatomic) UIBarButtonItem *confirmNavbarButton;
@property (assign, nonatomic) NSInteger remainingCharactersCount;

@end


@implementation CreateTutorialTextStepViewController

#pragma mark - Initialization

- (instancetype)initWithCompletion:(CreateTextStepCompletion)completionBlock
{
  self = [super initWithNibName:@"CreateTutorialTextStepView" bundle:nil];
  if (self) {
    _completionBlock = completionBlock;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self customizeNavigationBarButtons];
  [self.textView becomeFirstResponder];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self setupCharactersCount];
  self.textView.keyboardType = UIKeyboardTypeASCIICapable;
  
  [self updateTextStepRemainingCharactersCount];
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
  self.confirmNavbarButton.enabled = !([self overCharacterLimit]);
}

- (void)updateTextColor
{
  UIColor *textColor;
  if ([self overCharacterLimit]) {
    textColor = [UIColor redColor];
  } else {
    textColor = [UIColor blackColor];
  }
  self.textView.textColor = textColor;
}

- (BOOL)overCharacterLimit
{
  return (self.remainingCharactersCount < 0);
}

#pragma mark - Text transformation

- (NSString *)processedText
{
  return [self.textView.text stringByTrimmingWhitespaceAndNewline];
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
  [self dismissViewController];
  
  if (self.completionBlock) {
    self.completionBlock(self.processedText, nil);
  }
}

- (void)cancelButtonPressed
{
  if (!self.processedText.length) {
    [self dismissViewController];
    return;
  }
  
  [AlertFactory showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:^(BOOL discard) {
    if (discard) {
      [self dismissViewController];
    }
  }];
}

- (void)dismissViewController
{
  NSError *error = [NSError errorWithDomain:kCreateTutorialErrorDomain code:kTextStepDismissedError userInfo:nil];
  self.completionBlock(nil, error);
  [self.navigationController popViewControllerAnimated:YES];
}

@end
