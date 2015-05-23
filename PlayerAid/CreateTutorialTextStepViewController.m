//
//  PlayerAid
//

#import "CreateTutorialTextStepViewController.h"
#import "AlertFactory.h"


@interface CreateTutorialTextStepViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end


@implementation CreateTutorialTextStepViewController

#pragma mark - Initialization

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

#pragma mark - Actions

- (void)addTextButtonPressed
{
  [self dismissViewController];
  if (self.completionBlock) {
    self.completionBlock(YES, self.textView.text);
  }
}

- (void)cancelButtonPressed
{
  [AlertFactory showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:^(BOOL discard) {
    if (discard) {
      [self dismissViewController];
    }
  }];
}

- (void)dismissViewController
{
  self.completionBlock(NO, self.textView.text);
  [self.navigationController popViewControllerAnimated:YES];
}

@end
