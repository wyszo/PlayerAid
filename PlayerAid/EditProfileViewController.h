//
//  PlayerAid
//

@import UIKit;
#import "User.h"
#import <TWCommonLib/TWCommonMacros.h>

@interface EditProfileViewController : UIViewController

@property (nonatomic, copy) VoidBlock didUpdateUserProfileBlock;

NEW_AND_INIT_UNAVAILABLE
- (instancetype)initWithUser:(User *)user;

@end
