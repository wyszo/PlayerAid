//
//  PlayerAid
//

#import "User.h"


@interface EditProfileViewController : UIViewController

@property (nonatomic, copy) VoidBlock didUpdateUserProfileBlock;

NEW_AND_INIT_UNAVAILABLE
- (instancetype)initWithUser:(User *)user;

@end
