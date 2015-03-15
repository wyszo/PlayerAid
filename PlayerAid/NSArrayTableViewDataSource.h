//
//  PlayerAid
//


@interface NSArrayTableViewDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) void (^configureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);

- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView tableViewCellNibName:(NSString *)cellNibName;

@end
