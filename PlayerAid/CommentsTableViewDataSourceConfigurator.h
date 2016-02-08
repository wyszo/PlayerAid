//
//  PlayerAid
//

@import Foundation;
@import CoreData;
@import TWCommonLib;
@class Tutorial, TutorialComment;

NS_ASSUME_NONNULL_BEGIN

@interface CommentsTableViewDataSourceConfigurator : NSObject

NEW_AND_INIT_UNAVAILABLE

// for fetching root-level comments on a tutorial
- (instancetype)initWithTutorial:(Tutorial *)tutorial cellReuseIdentifier:(NSString *)cellReuseIdentifier fetchedResultsControllerDelegate:(id <NSFetchedResultsControllerDelegate>)delegate configureCellBlock:(CellWithObjectAtIndexPathBlock)configureCellBlock;

// for fetching comments made on a comment
- (instancetype)initWithComment:(TutorialComment *)comment cellReuseIdentifier:(NSString *)cellReuseIdentifier fetchedResultsControllerDelegate:(id <NSFetchedResultsControllerDelegate>)delegate configureCellBlock:(CellWithObjectAtIndexPathBlock)configureCellBlock;

- (TWCoreDataTableViewDataSource *)dataSource;

@end

NS_ASSUME_NONNULL_END
