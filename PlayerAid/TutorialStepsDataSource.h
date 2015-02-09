//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TutorialStepsDataSource : NSObject <UITableViewDataSource>

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
