//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "TutorialDetailsViewController.h"
#import "TutorialTableViewCell.h"
#import "TutorialsTableDataSource.h"
#import "TutorialCellHelper.h"
#import "TutorialStepsDataSource.h"


@interface TutorialDetailsViewController ()

@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) TutorialStepsDataSource *tutorialStepsDataSource;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupTableViewHeader];
  [self setupTutorialStepsTableView];
}

- (void)setupTableViewHeader
{
  self.tableView.tableHeaderView = self.headerTableView;
  self.headerTableViewDataSource = self.headerTableViewDataSource;
}

- (void)setupTutorialStepsTableView
{
  self.tutorialStepsDataSource = [[TutorialStepsDataSource alloc] initWithTableView:self.tableView];
}

- (TutorialsTableDataSource *)headerTableViewDataSource
{
  if (!_headerTableViewDataSource) {
    AssertTrueOrReturnNil(self.tutorial.objectID); // tutorial needs to have been set before this initialization
    _headerTableViewDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.headerTableView];
    _headerTableViewDataSource.predicate = [NSPredicate predicateWithFormat:@"self IN %@", @[ self.tutorial ]];
  }
  return _headerTableViewDataSource;
}

#pragma mark - Lazy Initalization

- (UITableView *)headerTableView
{
  if (!_headerTableView) {
    CGRect frame = CGRectMake(0, 0, 0, [TutorialCellHelper cellHeightFromNib]);
    _headerTableView = [[UITableView alloc] initWithFrame:frame];
    
    _headerTableView.allowsSelection = NO;
    _headerTableView.scrollEnabled = NO;
  }
  return _headerTableView;
}

@end
