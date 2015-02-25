//
//  PlayerAid
//

#import "Tutorial.h"

@protocol TutorialsTableViewDelegate;


@interface TutorialsTableDataSource : NSObject <UITableViewDelegate>

@property (nonatomic, weak) id<TutorialsTableViewDelegate> tutorialTableViewDelegate;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, copy) NSString *groupBy;
@property (nonatomic, assign) BOOL swipeToDeleteEnabled;
@property (nonatomic, assign) BOOL showSectionHeaders;
@property (nonatomic, assign, readonly) NSInteger totalNumberOfCells;

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end


@protocol TutorialsTableViewDelegate
@required
- (void)didSelectRowWithTutorial:(Tutorial *)tutorial;
- (void)numberOfRowsDidChange:(NSInteger)numberOfRows;
@end
