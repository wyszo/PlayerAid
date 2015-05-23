//
//  PlayerAid
//

#import "User.h"


/**
 * Wath out - if no user is provided on viewDidLoad, will load currently logged in user
 */
@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;

@end
