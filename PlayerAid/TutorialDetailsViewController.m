//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "TutorialDetailsViewController.h"
#import "TutorialTableViewCell.h"
#import "TutorialsTableDataSource.h"


@interface TutorialDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *headerTableView;
@property (strong, nonatomic) TutorialsTableDataSource *headerTableViewDataSource;

@end

@implementation TutorialDetailsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.headerTableView.allowsSelection = NO;
  self.headerTableViewDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.headerTableView];
  AssertTrueOrReturn(self.tutorial.objectID);
  self.headerTableViewDataSource.predicate = [NSPredicate predicateWithFormat:@"self IN %@", @[ self.tutorial ]];
  
  // TODO: setup tutorial tableView to display just one cell
  // TODO: display tutorial cell at the top
}

@end
