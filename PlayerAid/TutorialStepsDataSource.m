//
//  PlayerAid
//

#import "TutorialStepsDataSource.h"
#import <CoreData/CoreData.h>
#import <KZAsserts.h>
#import <NSManagedObject+MagicalFinders.h>
#import <NSManagedObject+MagicalRecord.h>
#import <NSManagedObjectContext+MagicalRecord.h>
#import <NSManagedObjectContext+MagicalSaves.h>
#import "TutorialStep.h"
#import "CoreDataTableViewDataSource.h"
#import "TutorialStepTableViewCell.h"
#import "TableViewFetchedResultsControllerBinder.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";

static const CGFloat kTutorialStepCellHeight = 120;


@interface TutorialStepsDataSource () <UITableViewDelegate>
@property (nonatomic, strong) CoreDataTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) TableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, strong) NSManagedObjectContext *context;
@end


@implementation TutorialStepsDataSource

#pragma mark - Initilization

// TODO: it's confusing that you don't set this class as a tableView dataSource and you just initialize it. Need to document it! 
- (instancetype)initWithTableView:(UITableView *)tableView tutorial:(Tutorial *)tutorial context:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(tableView);
  AssertTrueOrReturnNil(tutorial);
  
  self = [super init];
  if (self) {
    _tableView = tableView;
    _tableView.delegate = self;
    _tutorial = tutorial;
    _context = context;
    
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
  
  _tableViewDataSource.deleteCellOnSwipeBlock = ^(NSIndexPath *indexPath) {
    TutorialStep *tutorialStep = [weakSelf.tableViewDataSource objectAtIndexPath:indexPath];
    [tutorialStep MR_deleteInContext:weakSelf.context];
    [weakSelf.context MR_saveOnlySelfAndWait];
  };
  
  _tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"belongsTo == %@", weakSelf.tutorial];
    NSManagedObjectContext *context = weakSelf.context;
    if (!context) {
      context = [NSManagedObjectContext MR_defaultContext];
    }
    return [TutorialStep MR_fetchAllSortedBy:nil ascending:YES withPredicate:predicate groupBy:nil delegate:weakSelf.fetchedResultsControllerBinder inContext:context];
  };
  _tableView.dataSource = _tableViewDataSource;
}

- (void)configureCell:(TutorialStepTableViewCell *)tutorialStepCell atIndexPath:(NSIndexPath *)indexPath
{
  TutorialStep *tutorialStep = [self.tableViewDataSource objectAtIndexPath:indexPath];
  [tutorialStepCell configureWithTutorialStep:tutorialStep];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // TODO: read that value from xib (has to be dependent on tutorialStep type though)
  return kTutorialStepCellHeight;
}

@end
