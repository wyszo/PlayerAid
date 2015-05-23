//
//  PlayerAid
//

#import "Tutorial.h"
#import "User.h"

@protocol TutorialsTableViewDelegate;


@interface TutorialsTableDataSource : NSObject <UITableViewDelegate, TWObjectCountProtocol>

@property (nonatomic, weak) id<TutorialsTableViewDelegate> tutorialTableViewDelegate;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, copy) NSString *groupBy;
@property (nonatomic, assign) BOOL swipeToDeleteEnabled;
@property (nonatomic, assign) BOOL showSectionHeaders;
@property (nonatomic, copy) void (^userAvatarSelectedBlock)(User *user);

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithTableView:(UITableView *)tableView;
- (NSInteger)numberOfRowsForSectionNamed:(NSString *)sectionName;

@end


@protocol TutorialsTableViewDelegate

@required
- (void)didSelectRowWithTutorial:(Tutorial *)tutorial;

@optional
- (void)numberOfRowsDidChange:(NSInteger)numberOfRows;
@end
