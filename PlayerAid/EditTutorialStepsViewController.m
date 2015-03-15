//
//  PlayerAid
//

#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"
#import "AlertFactory.h"
#import "NSArrayTableViewDataSource.h"
#import "TableViewBasicDelegateObject.h"

static NSString *kNibName = @"EditTutorialStepsView";
static NSString *kTutorialCellName = @"EditTutorialCell";


@interface EditTutorialStepsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSMutableArray *tutorialSteps;
@property (weak, nonatomic) IBOutlet UITableView *tutorialStepsTableView;
@property (strong, nonatomic) NSArrayTableViewDataSource *tableViewDataSource;
@property (strong, nonatomic) TableViewBasicDelegateObject *delegateObject;

@end


@implementation EditTutorialStepsViewController

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
  
  self.delegateObject = [[TableViewBasicDelegateObject alloc] initWithCellHeight:60.0f];
  [self setupTableView];
}

- (void)setupTableView
{
  self.tableViewDataSource = [[NSArrayTableViewDataSource alloc] initWithArray:self.tutorialSteps tableView:self.tutorialStepsTableView tableViewCellNibName:kTutorialCellName];
  self.tableViewDataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
      // TODO: configure cell
  };
  self.tutorialStepsTableView.dataSource = self.tableViewDataSource;
  self.tutorialStepsTableView.delegate = self.delegateObject;
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
