//
//  PlayerAid
//

@interface EditTutorialStepsViewController : UIViewController

@property (nonatomic, copy) VoidBlock dismissBlock;

- (instancetype)initWithTutorialSteps:(NSArray *)tutorialSteps;
- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end
