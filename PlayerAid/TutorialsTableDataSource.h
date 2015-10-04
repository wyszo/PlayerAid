//
//  PlayerAid
//

#import "Tutorial.h"
#import "User.h"
#import "TutorialsTableViewDelegate.h"
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWObjectCountProtocol.h>


@interface TutorialsTableDataSource : NSObject <UITableViewDelegate, TWObjectCountProtocol>

@property (nonatomic, weak) id<TutorialsTableViewDelegate> tutorialTableViewDelegate;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, copy) NSString *groupBy;
@property (nonatomic, assign) BOOL swipeToDeleteEnabled;
@property (nonatomic, assign) BOOL showSectionHeaders;
@property (nonatomic, copy) void (^userAvatarSelectedBlock)(User *user);

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initAttachingToTableView:(UITableView *)tableView;
- (NSInteger)numberOfRowsForSectionNamed:(NSString *)sectionName;

@end
