//
//  PlayerAid
//

@import UIKit;
#import "TutorialComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentCell : UITableViewCell

@property (nonatomic, copy) VoidBlock willChangeCellHeightBlock;
@property (nonatomic, copy) VoidBlock didChangeCellHeightBlock;
@property (nonatomic, copy) VoidBlock updateCommentsTableViewFooterHeight;

@property (nonatomic, copy) void (^likeButtonPressedBlock)(TutorialComment *comment);
@property (nonatomic, copy) void (^unlikeButtonPressedBlock)(TutorialComment *comment);
@property (nonatomic, copy) void (^didPressUserAvatarOrName)(TutorialComment *comment);
@property (nonatomic, copy) void (^didPressReplyButtonBlock)(TutorialComment *comment);
@property (nonatomic, assign) BOOL replyButtonHidden;
@property (nonatomic, readonly) BOOL isCommentReplyCell;
@property (nonatomic, readonly) BOOL isExpanded;
@property (nonatomic, readonly) BOOL canHaveExpandedState;
@property (nonatomic, readonly) BOOL areRepliesExpanded;
@property (nonatomic, readonly) CGFloat commentLabelWidth;

// keep in mind that there might be replies on server that are not fetched yet!
@property (nonatomic, readonly) BOOL commentHasReplies;

- (void)configureWithTutorialComment:(TutorialComment *)comment allowInlineCommentReplies:(BOOL)allowInlineReplies;

/**
 Returns true if cell has been expanded or number of text lines < 5 (which means it doesn't need to expand)
 */
- (void)expandCell;
- (void)expandCommentReplies;

- (void)setHighlighted:(BOOL)highlighted;
- (void)setPreferredCommentLabelMaxLayoutWidth:(CGFloat)preferredWidth;


@end

NS_ASSUME_NONNULL_END