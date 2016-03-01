//
//  PlayerAid
//

@import UIKit;
#import "TutorialCommentsController.h"
@class Tutorial;

NS_ASSUME_NONNULL_BEGIN

@interface CommentsContainerViewController : UIViewController

/**
 A block should return true if 'edit cell' bar is visible or inputTextView in 'make comment' bar is firstResponder
 */
@property (nonatomic, copy) BOOL (^isAnyCommentBeingEditedOrAddedBlock)();
@property (nonatomic, copy) VoidBlock resignMakeOrEditCommentFirstResponderBlock;
@property (nonatomic, copy) BOOL (^isCommentBeingEditedBlock)(TutorialComment *comment);
@property (nonatomic, copy) void (^didPressReplyButtonBlock)(TutorialComment *comment);
@property (nonatomic, weak, readonly) UITableView *commentsTableView;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

@property (nonatomic, copy) VoidBlock updateCommentsTableViewFooterHeightBlock;

// mandatory, part of the initialization
- (void)setTutorialCommentsController:(TutorialCommentsController *)commentsController;

// mandatory, part of the initialization
- (void)setTutorial:(Tutorial *)tutorial;

// mandatory, part of the initialization
- (void)setEditCommentActionSheetOptionSelectedBlock:(EditCommentBlock)block;

// will trigger overlay update
- (void)commentsCountDidChange;

@end

NS_ASSUME_NONNULL_END
