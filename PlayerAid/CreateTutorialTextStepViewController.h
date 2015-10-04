//
//  PlayerAid
//

@import UIKit;
#import "TutorialStep.h"

typedef void (^CreateTextStepCompletion)(NSString *text, NSError *error);


@interface CreateTutorialTextStepViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle __unavailable;
- (instancetype)initWithCompletion:(CreateTextStepCompletion)completionBlock;
- (instancetype)initWithCompletion:(CreateTextStepCompletion)completionBlock tutorialTextStep:(TutorialStep *)tutorialStep;

@end
