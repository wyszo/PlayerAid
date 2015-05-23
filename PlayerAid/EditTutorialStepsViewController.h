//
//  PlayerAid
//

@interface EditTutorialStepsViewController : UIViewController

@property (nonatomic, copy) void (^dismissBlock)(BOOL saveChanges, NSArray *reorderedSteps);

- (instancetype)initWithTutorialSteps:(NSArray *)tutorialSteps;
- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end
