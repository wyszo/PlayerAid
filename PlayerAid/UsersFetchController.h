//
//  PlayerAid
//

@import Foundation;
#import <TWCommonLib/TWCommonMacros.h>
#import "User.h"


@interface UsersFetchController : NSObject

NEW_AND_INIT_UNAVAILABLE

+ (instancetype)sharedInstance;

/**
 Make /user API request. If request fails retries every 10 seconds.
 If this is the first time we request user data, present non-dismissable alert view until success.
 @param linkedWithFacebook  is user linked with Facebook? We'll store that value in user object. TODO: Technical debt: we shouldn't need to pass this parameter in here!!
 */
- (void)fetchCurrentUserProfileUserLinkedWithFacebook:(BOOL)linkedWithFacebook;
- (void)fetchCurrentUserProfile;

- (void)fetchUsersProfile:(User *)user;

/**
 * Returns currently logged in user 
 * @param context   Context in which to fetch User object, Optional
 */
- (User *)currentUserInContext:(NSManagedObjectContext *)context;

/**
 * Returns user object using context for current thread
 */
- (User *)currentUser;

@end
