//
//  PlayerAid
//

@interface EditTutorialStepsViewController : UIViewController

@property (nonatomic, copy) void (^dismissBlock)(BOOL saveChanges, NSArray *reorderedSteps);

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithTutorialSteps:(NSArray *)tutorialSteps;

@end
