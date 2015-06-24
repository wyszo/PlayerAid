//
//  PlayerAid
//

#import "User.h"


@interface UserManipulationController : NSObject

- (BOOL)currentUserFollowsUser:(User *)user;

- (void)sendFollowUserNetworkRequestAndUpdateDataModel:(User *)user completion:(VoidBlockWithError)completion;
- (void)sendUnfollowUserNetworkRequestAndUpdateDataModel:(User *)user completion:(VoidBlockWithError)completion;

@end
