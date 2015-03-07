//
//  PlayerAid
//


typedef void (^CreateTextStepCompletion)(NSString *text, NSError *error);


@interface CreateTutorialTextStepViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle __unavailable;
- (instancetype)initWithCompletion:(CreateTextStepCompletion)completionBlock;

@end
