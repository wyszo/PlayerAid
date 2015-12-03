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
@property (nonatomic, copy) BOOL (^isCommentBeingEditedBlock)(TutorialComment *comment);

// mandatory, part of the initialization
- (void)setTutorialCommentsController:(TutorialCommentsController *)commentsController;

// mandatory, part of the initialization
- (void)setTutorial:(Tutorial *)tutorial;

// mandatory, part of the initialization
- (void)setEditCommentActionSheetOptionSelectedBlock:(EditCommentBlock)block;

@end

NS_ASSUME_NONNULL_END
