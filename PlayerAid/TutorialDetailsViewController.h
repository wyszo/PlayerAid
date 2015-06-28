//
//  PlayerAid
//

#import "Tutorial.h"

@interface TutorialDetailsViewController : UIViewController

@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, copy) VoidBlock onDeallocBlock;

@end
