//
//  PlayerAid
//


/**
 TODO: Redirect all the unimplemented delegate methods to TableViewController!!
 TODO: Bind lifecycle to a tableView!!
 */
@interface NSSimpleTableViewDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, strong) IndexPathBlock cellSelectedBlock;
@property (nonatomic, assign) BOOL deselectCellOnTouch;

- (instancetype)initAndAttachToTableView:(UITableView *)tableView;

@end
