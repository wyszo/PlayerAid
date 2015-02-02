//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TutorialsTableDataSourceDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
