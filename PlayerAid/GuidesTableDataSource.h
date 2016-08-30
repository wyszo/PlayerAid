#import "Tutorial.h"
#import "User.h"
#import "GuidesTableViewDelegate.h"
#import "TutorialTableViewCell.h"
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWObjectCountProtocol.h>


@interface GuidesTableDataSource : NSObject <UITableViewDelegate, TWObjectCountProtocol>

@property (nonatomic, weak) id<GuidesTableViewDelegate> tutorialTableViewDelegate;
@property (nonatomic, nonnull, strong) NSPredicate *predicate;
@property (nonatomic, nullable, copy) NSString *groupBy;
@property (nonatomic, assign) BOOL swipeToDeleteEnabled;
@property (nonatomic, assign) BOOL showSectionHeaders;
@property (nonatomic, nullable, copy) void (^userAvatarOrNameSelectedBlock)(User * __nonnull user);
@property (nonatomic, nullable, copy) void (^didConfigureCellAtIndexPath)(TutorialTableViewCell * __nonnull cell, NSIndexPath *__nonnull indexPath);
@property (nonatomic, nullable, copy) IndexPathTransformBlock indexPathTransformBlock;

NEW_AND_INIT_UNAVAILABLE

- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView;

// call this after initailisation for the class to work
- (void)attachDataSourceAndDelegateToTableView;

- (NSInteger)numberOfRowsForSectionNamed:(nonnull NSString *)sectionName;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)sectionsCount;

- (nullable Tutorial *)tutorialAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end

@interface GuidesTableDataSource(Internal)

// you shouldn't need to call this explicitly (apart from a wrapper classes)
- (nullable TutorialTableViewCell *)cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

// you shouldn't need to call this explicitly (apart from a wrapper classes)
- (void)deleteGuideAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
