//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;
#import "CommentsTableViewDataSourceConfigurator.h"
#import "Tutorial.h"
#import "TutorialComment.h"

@interface CommentsTableViewDataSourceConfigurator()
@property (strong, nonatomic) TWCoreDataTableViewDataSource *dataSource;
@property (strong, nonatomic) Tutorial *tutorial;
@property (strong, nonatomic) TutorialComment *comment;
@property (strong, nonatomic) NSString *cellReuseIdentifier;
@property (strong, nonatomic) NSNumber *fetchLimit;
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

- (instancetype)initWithComment:(TutorialComment *)comment cellReuseIdentifier:(NSString *)cellReuseIdentifier fetchLimit:(NSNumber *)fetchLimit fetchedResultsControllerDelegate:(id <NSFetchedResultsControllerDelegate>)delegate configureCellBlock:(CellWithObjectAtIndexPathBlock)configureCellBlock {
  AssertTrueOrReturnNil(comment);
  AssertTrueOrReturnNil(cellReuseIdentifier.length);
  AssertTrueOrReturnNil(delegate);
  AssertTrueOrReturnNil(configureCellBlock);
  self = [super init];
  if (self) {
    _comment = comment;
    _cellReuseIdentifier = cellReuseIdentifier;
    _fetchLimit = fetchLimit;
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
  AssertTrueOrReturnNil(self.tutorial || self.comment);
  
  NSFetchRequest *fetchRequest = [TutorialComment MR_requestAll];
  fetchRequest.predicate = [self predicate];
  fetchRequest.sortDescriptors = [self sortDescriptors];
  
  if (self.fetchLimit.integerValue > 0) {
    fetchRequest.fetchLimit = self.fetchLimit.integerValue;
  }
  return fetchRequest;
}

- (NSPredicate *)predicate {
  AssertTrueOrReturnNil(self.tutorial || self.comment);

  if (self.tutorial) {
    return [NSPredicate predicateWithFormat:@"belongsToTutorial == %@ AND status == %d", self.tutorial, CommentStatusPublished];
  }
  AssertTrueOrReturnNil(self.comment);
  return [NSPredicate predicateWithFormat:@"isReplyTo == %@ AND status == %d", self.comment, CommentStatusPublished];
}

- (NSArray *)sortDescriptors
{
  NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc] initWithKey:@"createdOn" ascending:YES];
  return @[sortDescriptorDate];
}

#pragma mark - public

- (TWCoreDataTableViewDataSource *)dataSource
{
  return _dataSource;
}

@end
