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

@end

NS_ASSUME_NONNULL_END