//
//  PlayerAid
//

#import "TutorialStepsDataSource.h"
#import <CoreData/CoreData.h>
#import <KZAsserts.h>
#import <NSManagedObject+MagicalFinders.h>
#import "TutorialStep.h"
#import "CoreDataTableViewDataSource.h"
#import "TutorialStepTableViewCell.h"
#import "TableViewFetchedResultsControllerBinder.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";


@interface TutorialStepsDataSource ()
@property (nonatomic, strong) CoreDataTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) TableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@property (nonatomic, weak) UITableView *tableView;
@end


@implementation TutorialStepsDataSource

#pragma mark - Initilization

// TODO: it's confusing that you don't set this class as a tableView dataSource and you just initialize it. Need to document it! 
- (instancetype)initWithTableView:(UITableView *)tableView
{
  self = [super init];
  if (self) {
    _tableView = tableView;
//    _tableView.delegate = self;  // TODO: implement delegate methods
    
    [self initFetchedResultsControllerBinder];
    [self initTableViewDataSource];
    
    UINib *tableViewCellNib =  [UINib nibWithNibName:kTutorialStepCellNibName bundle:[NSBundle bundleForClass:[self class]]];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kTutorialStepCellReuseIdentifier];
  }
  return self;
}

- (void)initFetchedResultsControllerBinder
{
  __weak typeof(self) weakSelf = self;
  _fetchedResultsControllerBinder = [[TableViewFetchedResultsControllerBinder alloc] initWithTableView:_tableView configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:(TutorialStepTableViewCell *)cell atIndexPath:indexPath];
  }];
}

- (void)initTableViewDataSource
{
  __weak typeof(self) weakSelf = self;
  
  _tableViewDataSource = [[CoreDataTableViewDataSource alloc] initWithCellreuseIdentifier:kTutorialStepCellReuseIdentifier configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[TutorialStepTableViewCell class]]);
    TutorialStepTableViewCell *tutorialStepCell = (TutorialStepTableViewCell *)cell;
    [weakSelf configureCell:tutorialStepCell atIndexPath:indexPath];
  }];
  _tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    return [TutorialStep MR_fetchAllSortedBy:nil ascending:YES withPredicate:nil groupBy:nil delegate:weakSelf.fetchedResultsControllerBinder];
  };
  _tableView.dataSource = _tableViewDataSource;
}

- (void)configureCell:(TutorialStepTableViewCell *)tutorialStepCell atIndexPath:(NSIndexPath *)indexPath
{
  TutorialStep *tutorialStep = [self.tableViewDataSource objectAtIndexPath:indexPath];
  [tutorialStepCell configureWithTutorialStep:tutorialStep];
}

#pragma mark - NSFetchedResultsControllerDelegate

// TODO: make a separate object just handling FetchedResultsControllerDelegate, use ocde from TutorialsTableViewDataSource


@end
