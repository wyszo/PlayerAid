//
//  PlayerAid
//

@import UIKit;
#import "User.h"
#import <TWCommonLib/TWCommonTypes.h>

/**
 * Watch out - if no user is provided on viewDidLoad, will load currently logged in user
 */
@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, copy) VoidBlock backButtonAction;

@end
