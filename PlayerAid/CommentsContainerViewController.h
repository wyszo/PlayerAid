//
//  PlayerAid
//

@import UIKit;
@class Tutorial;
@class TutorialCommentsController;

NS_ASSUME_NONNULL_BEGIN

@interface CommentsContainerViewController : UIViewController

// mandatory, part of the initialization
- (void)setTutorialCommentsController:(TutorialCommentsController *)commentsController;

// mandatory, part of the initialization
- (void)setTutorial:(Tutorial *)tutorial;

@end

NS_ASSUME_NONNULL_END
