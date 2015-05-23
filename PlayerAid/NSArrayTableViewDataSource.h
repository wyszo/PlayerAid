//
//  PlayerAid
//

@interface NSArrayTableViewDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) CellAtIndexPathBlock configureCellBlock;

- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView tableViewCellNibName:(NSString *)cellNibName;

- (void)removeObjectAtIndex:(NSUInteger)index;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)objectCount;
- (NSArray *)allSteps;

@end
