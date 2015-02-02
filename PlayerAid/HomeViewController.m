//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import "TutorialsTableDataSourceDelegate.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *latestFilterView;
@property (weak, nonatomic) IBOutlet UIView *followingFilterView;

@property (strong, nonatomic) TutorialsTableDataSourceDelegate *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tutorialsTableView;

@end


@implementation HomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Home";
  
  // TODO: it's not clear that data source attaches itself to a tableView passed as a parameter, rethink this
  self.tutorialsTableDataSource = [[TutorialsTableDataSourceDelegate alloc] initWithTableView:self.tutorialsTableView];
}

#pragma mark - latest & following buttons bar

- (IBAction)latestFilterSelected:(id)sender
{
  // TODO: change predicate to show latest tutorials
}

- (IBAction)followingFilterSelected:(id)sender
{
  // TODO: change predicate to show tutorials of the users I follow
}

@end
