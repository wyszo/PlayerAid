//
//  PlayerAid
//

#import "TutorialStepsDataSource.h"
#import <CoreData/CoreData.h>
#import <NSManagedObject+MagicalFinders.h>
#import "TutorialStep.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";


@interface TutorialStepsDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) UITableView *tableView;
@end


@implementation TutorialStepsDataSource

#pragma mark - Initilization

- (instancetype)initWithTableView:(UITableView *)tableView
{
  self = [super init];
  if (self) {
    _tableView = tableView;
    _tableView.dataSource = self;
    
    UINib *tableViewCellNib =  [UINib nibWithNibName:kTutorialStepCellNibName bundle:[NSBundle bundleForClass:[self class]]];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kTutorialStepCellReuseIdentifier];
  }
  return self;
}

#pragma mark - CoreData fetching

- (NSFetchedResultsController *)fetchedResultsController
{
  if (!_fetchedResultsController) {
    _fetchedResultsController = [TutorialStep MR_fetchAllSortedBy:nil ascending:YES withPredicate:nil groupBy:nil delegate:self];
  }
  return _fetchedResultsController;
}

#pragma mark - TableView Data Source

// TODO: reuse methods from TutorialsTableViewDataSource


#pragma mark - NSFetchedResultsControllerDelegate 

// TODO: make a separate object just handling FetchedResultsControllerDelegate, use ocde from TutorialsTableViewDataSource


@end
