//
//  PlayerAid
//

#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"

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
  [self customizeNavbarButton:self.saveButton];
  [self customizeNavbarButton:self.cancelButton];
}

- (void)customizeNavbarButton:(UIButton *)button
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
  
}

@end
