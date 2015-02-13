//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tutorial.h"


@interface TutorialStepsDataSource : NSObject 

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithTableView:(UITableView *)tableView tutorial:(Tutorial *)tutorial;

@end
