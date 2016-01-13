//
//  PlayerAid
//

@import UIKit;
@import TWCommonLib;
@class Tutorial;

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentsViewController : UIViewController

@property (nonatomic, copy, nullable) void (^didChangeHeightBlock)(UIView * _Nonnull contentView, BOOL shouldScrollToCommentsBar);
@property (nonatomic, copy, nullable) VoidBlock didExpandBlock;
@property (nonatomic, copy, nullable) VoidBlock didMakeACommentBlock;

@property (nonatomic, copy, nullable) VoidBlock willExpandBlock;
@property (nonatomic, copy, nullable) VoidBlock didFoldBlock;

@property (nonatomic, copy, nullable) BlockWithFloatParameter parentTableViewScrollAnimatedBlock; // required
@property (nonatomic, copy, nullable) FloatReturningBlock parentTableViewFooterTopBlock; // required
@property (nonatomic, weak) UINavigationController *parentNavigationController; // required

// adds a large gap below comments if set to yes
@property (nonatomic, assign) BOOL shouldCompensateForOpenKeyboard;


- (void)setTutorial:(Tutorial * _Nonnull)tutorial; // required

- (void)recalculateSize;

/**
 This used to be part of internal implementation called from dealloc, but when a memory leak was accidentally introduced, it broke instantly.
 Since it completely breaks the ability to see the comments when it breaks, now it's triggered manually so that even when there are memory
 management bugs in the code, the logic won't break. Technical debt!
 */
- (void)dismissAllInputViews;

- (void)slideOutActiveInputViewIfCommentsExpanded;
- (void)slideInActiveInputViewIfCommentsExpanded;

@end

NS_ASSUME_NONNULL_END