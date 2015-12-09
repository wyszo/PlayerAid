//
//  PlayerAid
//

@import UIKit;
@import TWCommonLib;
@class Tutorial;

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentsViewController : UIViewController

@property (nonatomic, copy, nullable) void (^didChangeHeightBlock)(UIView * _Nonnull contentView);
@property (nonatomic, copy, nullable) VoidBlock didExpandBlock;

@property (nonatomic, copy, nullable) VoidBlock willExpandBlock;
@property (nonatomic, copy, nullable) VoidBlock didFoldBlock;

// mandatory, required for initialization
- (void)setTutorial:(Tutorial * _Nonnull)tutorial;

// mandatory, dirty way of calculating desired comments view height when expanded
- (void)setNavbarScreenHeight:(CGFloat)navbarHeight;


/**
 This used to be part of internal implementation called from dealloc, but when a memory leak was accidently introduced, it broke instantly. Since it completely breaks the ability to see the comments when it breaks, now it's triggered manually so that even when there are memory management bugs in the code, the logic won't break. Technical debt!
 */
- (void)dismissAllInputViews;

@end

NS_ASSUME_NONNULL_END