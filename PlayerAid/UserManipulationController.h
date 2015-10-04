//
//  PlayerAid
//

@import Foundation;
#import "User.h"
#import <TWCommonLib/TWCommonTypes.h>

@interface UserManipulationController : NSObject

- (void)toggleFollowButtonPressedSendRequestUpdateModelForUser:(User *)user completion:(VoidBlockWithError)completion;

- (BOOL)loggedInUserFollowsUser:(User *)user;

@end
