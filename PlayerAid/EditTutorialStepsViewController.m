//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "EditTutorialStepsViewController.h"
#import "FontsHelper.h"
#import "AlertFactory.h"
#import "EditTutorialTableViewCell.h"
#import "AlertFactory.h"
#import "ColorsHelper.h"
#import "CommonViews.h"

static NSString *kNibName = @"EditTutorialStepsView";
static NSString *kTutorialCellName = @"EditTutorialCell";
static const CGFloat kEditTutorialCellHeight = 76.0f;
static const CGFloat kTableViewTopInset = 14.0f;

@interface EditTutorialStepsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tutorialStepsTableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSMutableArray *tutorialSteps;
@property (strong, nonatomic) TWTableViewEditingStyleDelegate *tableViewDelegate;
@property (strong, nonatomic) TWArrayTableViewDataSource *tableViewDataSource;
@end


@implementation EditTutorialStepsViewController

#pragma mark - Setup

- (instancetype)initWithTutorialSteps:(NSArray *)tutorialSteps
{
  self = [super initWithNibName:kNibName bundle:nil];
  if (self) {
    _tutorialSteps = [self mutableTutorialStepsArraySortedByOrder:tutorialSteps];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self customizeButton:self.saveButton];
  [self customizeButton:self.cancelButton];

  self.backgroundView.backgroundColor = [ColorsHelper editTutorialStepsBackgroundColor];
  [self setupTableView];
}

- (void)setupTableView
{
  self.tutorialStepsTableView.rowHeight = kEditTutorialCellHeight;
  self.tutorialStepsTableView.tableHeaderView = [CommonViews smallTableHeaderOrFooterView];
  self.tutorialStepsTableView.contentInset = UIEdgeInsetsMake(kTableViewTopInset, 0, 0, 0);
  [self setupTableViewDataSource];
  
  [self.tutorialStepsTableView setEditing:YES];
  self.tableViewDelegate = [[TWTableViewEditingStyleDelegate alloc] initWithUITableViewCellEditingStyle:UITableViewCellEditingStyleNone attachToTableView:self.tutorialStepsTableView];
}

- (void)setupTableViewDataSource
{
  self.tableViewDataSource = [[TWArrayTableViewDataSource alloc] initWithArray:self.tutorialSteps attachToTableView:self.tutorialStepsTableView cellNibName:kTutorialCellName];
  
  defineWeakSelf();
  self.tableViewDataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  };
}

#pragma mark - Auxiliary methods

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

- (NSMutableArray *)mutableTutorialStepsArraySortedByOrder:(NSArray *)tutorialSteps
{
  AssertTrueOrReturnNil(tutorialSteps);
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
  return [[tutorialSteps sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
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
      [weakSelf.tableViewDataSource removeObject:objectAtIndexPath];
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
      AssertTrueOr(allSteps.count, ;);
      [weakSelf tutorialStepsUpdateOrderValuesByOrder:allSteps];
      weakSelf.dismissBlock(YES, allSteps);
    }
  } cancelAction:nil];
}

- (IBAction)cancelButtonPressed:(id)sender
{
  defineWeakSelf();
  [AlertFactory showOKCancelAlertViewWithTitle:nil message:@"Discard changes?" okTitle:@"Yes" okAction:^{
    CallBlock(weakSelf.dismissBlock, NO, nil);
  } cancelAction:nil];
}

@end
