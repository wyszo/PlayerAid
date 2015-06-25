//
//  PlayerAid
//

#import "User.h"


@interface UserManipulationController : NSObject

- (void)toggleFollowButtonPressedSendRequestUpdateModelForUser:(User *)user completion:(VoidBlockWithError)completion;

- (BOOL)loggedInUserFollowsUser:(User *)user;

@end
