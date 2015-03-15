//
//  PlayerAid
//

#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"
#import "AlertFactory.h"
#import "NSArrayTableViewDataSource.h"

static NSString *kNibName = @"EditTutorialStepsView";


@interface EditTutorialStepsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSMutableArray *tutorialSteps;
@property (weak, nonatomic) IBOutlet UITableView *tutorialStepsTableView;
@property (strong, nonatomic) NSArrayTableViewDataSource *tableViewDataSource;

@end

@implementation EditTutorialStepsViewController

// TODO: implement heightForRowAtIndexPath (and possibly other delegate methods)

- (instancetype)initWithTutorialSteps:(NSArray *)tutorialSteps
{
  self = [super initWithNibName:kNibName bundle:nil];
  if (self) {
    _tutorialSteps = [tutorialSteps mutableCopy];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self customizeButton:self.saveButton];
  [self customizeButton:self.cancelButton];
  
  self.tableViewDataSource = [[NSArrayTableViewDataSource alloc] initWithArray:self.tutorialSteps tableView:self.tutorialStepsTableView tableViewCellNibName:@"EditTutorialCell"];
  self.tutorialStepsTableView.dataSource = self.tableViewDataSource;
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
    if (self.dismissBlock) {
      self.dismissBlock();
    }
  } cancelAction:nil];
}

@end
