//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tutorial.h"

@protocol TutorialsTableViewDelegate;


@interface TutorialsTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TutorialsTableViewDelegate> tutorialTableViewDelegate;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, assign) BOOL swipeToDeleteEnabled;

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end


@protocol TutorialsTableViewDelegate
@required
- (void)didSelectRowWithTutorial:(Tutorial *)tutorial;
@end
