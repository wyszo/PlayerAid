//
//  PlayerAid
//


@interface NSArrayTableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView tableViewCellNibName:(NSString *)cellNibName;

@end
