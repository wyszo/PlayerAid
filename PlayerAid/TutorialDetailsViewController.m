//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "TutorialDetailsViewController.h"
#import "TutorialTableViewCell.h"
#import "TutorialsTableDataSource.h"
#import "TutorialCellHelper.h"


@interface TutorialDetailsViewController ()

@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;
@property (strong, nonatomic) UITableView *headerTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation TutorialDetailsViewController

#pragma mark - Initalization

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupTableView];
}

- (void)setupTableView
{
  self.headerTableViewDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.headerTableView];
  AssertTrueOrReturn(self.tutorial.objectID);
  self.headerTableViewDataSource.predicate = [NSPredicate predicateWithFormat:@"self IN %@", @[ self.tutorial ]];
  
  self.tableView.tableHeaderView = self.headerTableView;
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
