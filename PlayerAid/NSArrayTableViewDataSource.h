//
//  PlayerAid
//

@interface NSArrayTableViewDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) CellAtIndexPathBlock configureCellBlock;

- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView tableViewCellNibName:(NSString *)cellNibName;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)objectCount;

@end
