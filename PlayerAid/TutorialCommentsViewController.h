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

// mandatory, required for initialization
- (void)setTutorial:(Tutorial * _Nonnull)tutorial;

// mandatory, dirty way of calculating desired comments view height when expanded
- (void)setNavbarScreenHeight:(CGFloat)navbarHeight;

@end

NS_ASSUME_NONNULL_END