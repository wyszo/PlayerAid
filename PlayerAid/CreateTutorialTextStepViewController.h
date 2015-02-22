//
//  PlayerAid
//


@interface CreateTutorialTextStepViewController : UIViewController

@property (copy, nonatomic) void (^completionBlock)(BOOL shouldSaveStep, NSString *textStep);

@end
