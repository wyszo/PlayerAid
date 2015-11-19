//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;
#import "CommentsTableViewDataSource.h"
#import "Tutorial.h"
#import "TutorialComment.h"

@interface CommentsTableViewDataSourceConfigurator()
@property (strong, nonatomic) TWCoreDataTableViewDataSource *dataSource;
@property (strong, nonatomic) Tutorial *tutorial;
@property (strong, nonatomic) NSString *cellReuseIdentifier;
@property (weak, nonatomic) id <NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;
@property (copy, nonatomic) CellWithObjectAtIndexPathBlock configureCellBlock;
@end

@implementation CommentsTableViewDataSourceConfigurator

- (instancetype)initWithTutorial:(nonnull Tutorial *)tutorial cellReuseIdentifier:(nonnull NSString *)cellReuseIdentifier fetchedResultsControllerDelegate:(nonnull id <NSFetchedResultsControllerDelegate>)delegate configureCellBlock:(CellWithObjectAtIndexPathBlock)configureCellBlock
{
  AssertTrueOrReturnNil(tutorial);
  AssertTrueOrReturnNil(cellReuseIdentifier.length);
  AssertTrueOrReturnNil(delegate);
  AssertTrueOrReturnNil(configureCellBlock);
  self = [super init];
  if (self) {
    _tutorial = tutorial;
    _cellReuseIdentifier = cellReuseIdentifier;
    _fetchedResultsControllerDelegate = delegate;
    _configureCellBlock = configureCellBlock;
    [self setupCommentsTableViewDataSource];
  }
  return self;
}

- (void)setupCommentsTableViewDataSource
{
  defineWeakSelf();
  self.dataSource = [[TWCoreDataTableViewDataSource alloc] initWithCellReuseIdentifier:self.cellReuseIdentifier configureCellWithObjectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    CallBlock(weakSelf.configureCellBlock, cell, object, indexPath);
  }];
  self.dataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    defineStrongSelf();
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSFetchRequest *fetchRequest = [strongSelf fetchRequest];
    
    NSFetchedResultsController *fetchedResultsController = [TutorialComment MR_fetchController:fetchRequest delegate:strongSelf.fetchedResultsControllerDelegate useFileCache:NO groupedBy:nil inContext:context];
    [fetchedResultsController tw_performFetchAssertResults];
    return fetchedResultsController;
  };
}

- (NSFetchRequest *)fetchRequest
{
  AssertTrueOrReturnNil(self.tutorial);
  
  NSFetchRequest *fetchRequest = [TutorialComment MR_requestAllSortedBy:@"createdOn" ascending:YES];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"belongsToTutorial == %@", self.tutorial];
  // fetchRequest.sortDescriptors = [self sortDescriptors];
  return fetchRequest;
}

- (NSArray *)sortDescriptors
{
  return nil;
  
  // NOT_IMPLEMENTED_YET_RETURN_NIL
  // 1. sort by # of likes, 2. sort by creationDate
}

#pragma mark - public

- (TWCoreDataTableViewDataSource *)dataSource
{
  return _dataSource;
}

@end
