//
//  PlayerAid
//

@interface TableViewBasicDelegateObject : NSObject <UITableViewDelegate>

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

- (instancetype)initWithCellHeight:(CGFloat)cellHeight;

@end
