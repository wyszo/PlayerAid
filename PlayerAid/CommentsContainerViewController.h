//
//  PlayerAid
//

@import UIKit;
#import "TutorialCommentsController.h"
@class Tutorial;


NS_ASSUME_NONNULL_BEGIN

@interface CommentsContainerViewController : UIViewController

// mandatory, part of the initialization
- (void)setTutorialCommentsController:(TutorialCommentsController *)commentsController;

// mandatory, part of the initialization
- (void)setTutorial:(Tutorial *)tutorial;

// mandatory, part of the initialization
- (void)setEditCommentActionSheetOptionSelectedBlock:(EditCommentBlock)block;

@end

NS_ASSUME_NONNULL_END
