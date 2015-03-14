//
//  PlayerAid
//

@interface EditTutorialStepsViewController : UIViewController

@property (nonatomic, copy) VoidBlock dismissBlock;

- (instancetype)initWithTutorialSteps:(NSOrderedSet *)tutorialSteps;
- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end
