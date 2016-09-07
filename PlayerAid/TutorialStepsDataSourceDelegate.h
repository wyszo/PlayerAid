//
//  PlayerAid
//

#import "Tutorial.h"
#import "TutorialStepTableViewCell.h"
#import <TWCommonLib/TWCommonTypes.h>

@interface TutorialStepsDataSourceDelegate : NSObject

@property (nonatomic, weak) UIViewController *moviePlayerParentViewController;
@property (nonatomic, copy) VoidBlock cellDeletionCompletionBlock;

/** defaults to NO */
@property (nonatomic, assign) BOOL scrollToBottomWhenLastItemAdded;

NEW_AND_INIT_UNAVAILABLE

/**
 @param tableView
 @param tutorial  TutorialSteps of which tutorial do we show
 @param context   Optional, can be nil (nil means default context)
 @param allowsEditing  Determines whether we can delete and reorder rows
 */
- (instancetype)initWithTableView:(UITableView *)tableView tutorial:(Tutorial *)tutorial context:(NSManagedObjectContext *)context allowsEditing:(BOOL)allowsEditing tutorialStepTableViewCellDelegate:(id<TutorialStepTableViewCellDelegate>)cellDelegate;

@end
