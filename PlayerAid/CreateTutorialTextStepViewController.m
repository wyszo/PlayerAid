//
//  PlayerAid
//

#import "CreateTutorialTextStepViewController.h"
#import "AlertFactory.h"
#import "NSString+Trimming.h"


@interface CreateTutorialTextStepViewController ()
@property (copy, nonatomic) CreateTextStepCompletion completionBlock;
@property (weak, nonatomic) IBOutlet UITextView *textView;
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
}

- (void)customizeNavigationBarButtons
{
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(addTextButtonPressed)];
}

#pragma mark - Text transformation

- (NSString *)processedText
{
  return [self.textView.text stringByTrimmingWhitespaceAndNewline];
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
  const NSInteger kTextStepDismissedError = 1;
  NSError *error = [NSError errorWithDomain:@"CreateTutorialDomain" code:kTextStepDismissedError userInfo:nil];
  self.completionBlock(nil, error);
  [self.navigationController popViewControllerAnimated:YES];
}

@end
