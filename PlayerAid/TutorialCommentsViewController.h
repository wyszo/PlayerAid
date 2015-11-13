//
//  PlayerAid
//

@import UIKit;
@import TWCommonLib;
@class Tutorial;

@interface TutorialCommentsViewController : UIViewController

@property (nonatomic, copy, nullable) void (^didChangeHeightBlock)(UIView * _Nonnull contentView);
@property (nonatomic, copy, nullable) VoidBlock didExpandBlock;

NEW_AND_INIT_UNAVAILABLE

- (nonnull instancetype)initWithTutorial:(nonnull Tutorial *)tutorial;

@end
