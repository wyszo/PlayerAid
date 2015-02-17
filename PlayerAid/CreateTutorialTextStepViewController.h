//
//  PlayerAid
//

#import <UIKit/UIKit.h>

@interface CreateTutorialTextStepViewController : UIViewController

@property (copy, nonatomic) void (^completionBlock)(BOOL shouldSaveStep, NSString *textStep);

@end
