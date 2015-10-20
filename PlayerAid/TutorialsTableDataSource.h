//
//  PlayerAid
//

#import "Tutorial.h"
#import "User.h"
#import "TutorialsTableViewDelegate.h"
#import "TutorialTableViewCell.h"
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWObjectCountProtocol.h>


@interface TutorialsTableDataSource : NSObject <UITableViewDelegate, TWObjectCountProtocol>

@property (nonatomic, weak) id<TutorialsTableViewDelegate> tutorialTableViewDelegate;
@property (nonatomic, nonnull, strong) NSPredicate *predicate;
@property (nonatomic, nullable, copy) NSString *groupBy;
@property (nonatomic, assign) BOOL swipeToDeleteEnabled;
@property (nonatomic, assign) BOOL showSectionHeaders;
@property (nonatomic, nullable, copy) void (^userAvatarSelectedBlock)(User * __nonnull user);
@property (nonatomic, nullable, copy) void (^didConfigureCellAtIndexPath)(TutorialTableViewCell * __nonnull cell, NSIndexPath *__nonnull indexPath);

NEW_AND_INIT_UNAVAILABLE

- (nonnull instancetype)initAttachingToTableView:(nonnull UITableView *)tableView;
- (NSInteger)numberOfRowsForSectionNamed:(nonnull NSString *)sectionName;
- (nullable Tutorial *)tutorialAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
