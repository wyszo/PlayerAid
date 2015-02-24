//
//  PlayerAid
//


@interface CoreDataTableViewDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) NSFetchedResultsController* (^fetchedResultsControllerLazyInitializationBlock)();
@property (copy, nonatomic) void (^deleteCellOnSwipeBlock)(NSIndexPath *indexPath);
@property (copy, nonatomic) void (^moveRowAtIndexPathToIndexPathBlock)(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath);


- (instancetype)initWithCellreuseIdentifier:(NSString *)cellReuseIdentifier
                         configureCellBlock:(void (^)(UITableViewCell *cell, NSIndexPath *indexPath))configureCellBlock;
- (void)resetFetchedResultsController;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id<NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSInteger)section;

@end
