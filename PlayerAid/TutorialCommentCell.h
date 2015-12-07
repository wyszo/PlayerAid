//
//  PlayerAid
//

@import UIKit;
#import "TutorialComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentCell : UITableViewCell

@property (nonatomic, copy) VoidBlock willChangeCellHeightBlock;
@property (nonatomic, copy) VoidBlock didChangeCellHeightBlock;
@property (nonatomic, copy) void (^likeButtonPressedBlock)(TutorialComment *comment);

- (void)configureWithTutorialComment:(TutorialComment *)comment;

/**
 Returns true if cell has been expanded or number of text lines < 5 (which means it doesn't need to expand)
 */
- (BOOL)isExpanded;
- (void)expandCell;

- (void)setSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END