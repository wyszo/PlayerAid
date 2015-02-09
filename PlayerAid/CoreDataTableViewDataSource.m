//
//  PlayerAid
//

#import "CoreDataTableViewDataSource.h"
#import <NSManagedObject+MagicalFinders.h>
#import <KZAsserts.h>


@interface CoreDataTableViewDataSource ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (copy, nonatomic) void (^configureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
@property (strong, nonatomic) NSString *cellReuseIdentifier;

@end


@implementation CoreDataTableViewDataSource

#pragma mark - Initialization

- (instancetype)initWithCellreuseIdentifier:(NSString *)cellReuseIdentifier
                         configureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock;
{
  self = [super init];
  if (self) {
    _configureCellBlock = configureCellBlock;
    _cellReuseIdentifier = cellReuseIdentifier;
  }
  return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self sectionInfoForSection:section].numberOfObjects;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self sectionInfoForSection:section].name;
}

- (id<NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSInteger)section
{
  return self.fetchedResultsController.sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier];
  
  if (self.configureCellBlock) {
    self.configureCellBlock(cell, indexPath);
  }
  return cell;
}

#pragma mark - Deleting cells

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return (self.deleteCellOnSwipeBlock != nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.deleteCellOnSwipeBlock && editingStyle == UITableViewCellEditingStyleDelete) {
    self.deleteCellOnSwipeBlock(indexPath);
  }
}

#pragma mark - Lazy Initialization

- (NSFetchedResultsController *)fetchedResultsController
{
  if (!_fetchedResultsController) {
    if (self.fetchedResultsControllerLazyInitializationBlock) {
      _fetchedResultsController = self.fetchedResultsControllerLazyInitializationBlock();
    }
  }
  return _fetchedResultsController;
}

#pragma mark - Other methods

- (void)resetFetchedResultsController
{
  _fetchedResultsController = nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoForSection:indexPath.section];
  AssertTrueOrReturnNil(sectionInfo.objects.count > indexPath.row);
  return sectionInfo.objects[indexPath.row];
}

@end
