//
//  PlayerAid
//

#import "User.h"


@interface UserManipulationController : NSObject

- (BOOL)currentUserFollowsUser:(User *)user;

- (void)sendFollowUserNetworkRequestAndUpdateDataModel:(User *)user;
- (void)sendUnfollowUserNetworkRequestAndUpdateDataModel:(User *)user;

@end
