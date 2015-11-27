//
//  PlayerAid
//

@import UIKit;
#import "TutorialComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentCell : UITableViewCell

@property (nonatomic, copy) VoidBlock willChangeCellHeightBlock;
@property (nonatomic, copy) VoidBlock didChangeCellHeightBlock;

- (void)configureWithTutorialComment:(TutorialComment *)comment;

/**
 Returns true if cell has been expanded or number of text lines < 5 (which means it doesn't need to expand)
 */
- (BOOL)isExpanded;
- (void)expandCell;

@end

NS_ASSUME_NONNULL_END