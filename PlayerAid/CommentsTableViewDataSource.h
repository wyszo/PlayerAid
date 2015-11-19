//
//  PlayerAid
//

@import Foundation;
@import CoreData;
@import TWCommonLib;
@class Tutorial;

NS_ASSUME_NONNULL_BEGIN

@interface CommentsTableViewDataSourceConfigurator : NSObject

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithTutorial:(Tutorial *)tutorial cellReuseIdentifier:(NSString *)cellReuseIdentifier fetchedResultsControllerDelegate:(id <NSFetchedResultsControllerDelegate>)delegate configureCellBlock:(CellWithObjectAtIndexPathBlock)configureCellBlock;

- (TWCoreDataTableViewDataSource *)dataSource;

@end

NS_ASSUME_NONNULL_END
