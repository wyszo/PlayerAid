//
//  PlayerAid
//

// TODO: dataSource should bind it's lifecycle to a tableView lifespan

@interface NSArrayTableViewDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) CellAtIndexPathBlock configureCellBlock;

/**
 For tableViews with cells from xib
 */
- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView tableViewCellNibName:(NSString *)cellNibName;

/**
 For tableViews with prototype cells from Storyboard
 */
- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView cellDequeueIdentifier:(NSString *)cellDequeueIdentifier;

- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)objectCount;
- (NSArray *)allSteps;

@end
