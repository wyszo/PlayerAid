//
//  PlayerAid
//

#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"
#import "AlertFactory.h"

static NSString *kNibName = @"EditTutorialStepsView";

@interface EditTutorialStepsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation EditTutorialStepsViewController

- (instancetype)init
{
    self = [super initWithNibName:kNibName bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self customizeButton:self.saveButton];
  [self customizeButton:self.cancelButton];
}

- (void)customizeButton:(UIButton *)button
{
  AssertTrueOrReturn(button);
  button.titleLabel.font = [FontsHelper navbarButtonsFont];
}

#pragma mark IBActions

- (IBAction)saveButtonPressed:(id)sender
{
  
}

- (IBAction)cancelButtonPressed:(id)sender
{
  [AlertFactory showOKCancelAlertViewWithTitle:nil message:@"Discard changes?" okTitle:@"Yes" okAction:^{
    // TODO: should dismiss here
  } cancelAction:nil];
}

@end
