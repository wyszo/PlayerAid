//
//  PlayerAid
//

#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"

static NSString *kNibName = @"EditTutorialStepsView";

@interface EditTutorialStepsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cancelButton;
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
  self.cancelButton.font = [FontsHelper navbarButtonsFont];
}

#pragma mark IBActions

- (IBAction)cancelButtonPressed:(id)sender
{
  
}

@end
