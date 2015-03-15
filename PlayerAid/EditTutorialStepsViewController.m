//
//  PlayerAid
//

#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"
#import "AlertFactory.h"
#import "NSArrayTableViewDataSource.h"
#import "TableViewBasicDelegateObject.h"
#import "EditTutorialTableViewCell.h"
#import "AlertFactory.h"

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
    _tutorialSteps = [self mutableTutorialStepsArraySortedByOrder:tutorialSteps];
  }
  return self;
}

- (NSMutableArray *)mutableTutorialStepsArraySortedByOrder:(NSArray *)tutorialSteps
{
  AssertTrueOrReturnNil(tutorialSteps);
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
  return [[tutorialSteps sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self customizeButton:self.saveButton];
  [self customizeButton:self.cancelButton];
  
  self.delegateObject = [[TableViewBasicDelegateObject alloc] initWithCellHeight:60.0f];
  [self setupTableView];
  [self.tutorialStepsTableView setEditing:YES];
}

- (void)setupTableView
{
  self.tableViewDataSource = [[NSArrayTableViewDataSource alloc] initWithArray:self.tutorialSteps tableView:self.tutorialStepsTableView tableViewCellNibName:kTutorialCellName];
  defineWeakSelf();
  self.tableViewDataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  };
  self.tutorialStepsTableView.dataSource = self.tableViewDataSource;
  self.tutorialStepsTableView.delegate = self.delegateObject;
}

- (void)customizeButton:(UIButton *)button
{
  AssertTrueOrReturn(button);
  button.titleLabel.font = [FontsHelper navbarButtonsFont];
}

- (void)tutorialStepsUpdateOrderValuesByOrder:(NSArray *)tutorialSteps
{
  AssertTrueOrReturn(tutorialSteps);
  [tutorialSteps enumerateObjectsUsingBlock:^(TutorialStep *step, NSUInteger idx, BOOL *stop) {
    step.orderValue = idx;
  }];
}

#pragma mark - Cell configuration

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn(cell);
  AssertTrueOrReturn([cell isKindOfClass:[EditTutorialTableViewCell class]]);
  EditTutorialTableViewCell *editTutorialCell = (EditTutorialTableViewCell *)cell;
  
  id objectAtIndexPath = [self.tableViewDataSource objectAtIndexPath:indexPath];
  AssertTrueOrReturn([objectAtIndexPath isKindOfClass:[TutorialStep class]]);
  TutorialStep *step = (TutorialStep *)objectAtIndexPath;
  
  [editTutorialCell configureWithTutorialStep:step];
  
  defineWeakSelf();
  editTutorialCell.deleteCellBlock = ^() {
    [AlertFactory showDeleteTutorialStepAlertConfirmationWithOKAction:^{
      [weakSelf.tableViewDataSource removeObjectAtIndex:indexPath.row];
      [weakSelf.tutorialStepsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
  };
}

#pragma mark IBActions

- (IBAction)saveButtonPressed:(id)sender
{
  defineWeakSelf();
  [AlertFactory showOKCancelAlertViewWithTitle:nil message:@"Save changes?" okTitle:@"Yes" okAction:^{
    if (weakSelf.dismissBlock) {
      NSArray *allSteps = weakSelf.tableViewDataSource.allSteps;
      [weakSelf tutorialStepsUpdateOrderValuesByOrder:allSteps];
      weakSelf.dismissBlock(YES, weakSelf.tableViewDataSource.allSteps);
    }
  } cancelAction:nil];
}

- (IBAction)cancelButtonPressed:(id)sender
{
  defineWeakSelf();
  [AlertFactory showOKCancelAlertViewWithTitle:nil message:@"Discard changes?" okTitle:@"Yes" okAction:^{
    if (weakSelf.dismissBlock) {
      weakSelf.dismissBlock(NO, nil);
    }
  } cancelAction:nil];
}

@end
