//
//  PlayerAid
//

#import "TutorialStepsDataSource.h"
#import <CoreData/CoreData.h>
#import <NSManagedObject+MagicalFinders.h>
#import "TutorialStep.h"
#import "CoreDataTableViewDataSource.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";


@interface TutorialStepsDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) CoreDataTableViewDataSource *tableViewDataSource;
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
    [self initTableViewDataSource];
    
    UINib *tableViewCellNib =  [UINib nibWithNibName:kTutorialStepCellNibName bundle:[NSBundle bundleForClass:[self class]]];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kTutorialStepCellReuseIdentifier];
  }
  return self;
}

- (void)initTableViewDataSource
{
  __weak typeof(self) weakSelf = self;
  
  _tableViewDataSource = [[CoreDataTableViewDataSource alloc] initWithCellreuseIdentifier:kTutorialStepCellReuseIdentifier configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    // TODO: configure Tutorial Step cell
  }];
  _tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    return [TutorialStep MR_fetchAllSortedBy:nil ascending:YES withPredicate:nil groupBy:nil delegate:weakSelf];
  };
  _tableView.dataSource = _tableViewDataSource;
}

#pragma mark - NSFetchedResultsControllerDelegate 

// TODO: make a separate object just handling FetchedResultsControllerDelegate, use ocde from TutorialsTableViewDataSource


@end
