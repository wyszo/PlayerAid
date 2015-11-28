//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "EditCommentInputViewController.h"

static NSString *const kNibName = @"EditCommentInputView";

@interface EditCommentInputViewController ()
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

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
}

#pragma mark - Public

- (void)setCommentText:(NSString *)commentText
{
  self.inputTextView.text = commentText;
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

@end
