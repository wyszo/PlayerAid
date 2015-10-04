//
//  PlayerAid
//

@import UIKit;
#import "Tutorial.h"
#import <TWCommonLib/TWCommonTypes.h>

@interface TutorialDetailsViewController : UIViewController

@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, copy) VoidBlock onDeallocBlock;

@end
