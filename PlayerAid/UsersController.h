//
//  PlayerAid
//

#import "User.h"


@interface UsersController : NSObject

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

+ (instancetype)sharedInstance;

/**
 Make /user API request. If request fails retries every 10 seconds.
 If this is the first time we request user data, present non-dismissable alert view until success.
 */
- (void)updateCurrentUserProfile;

- (void)updateUsersProfile:(User *)user;

/**
 * Returns currently logged in user 
 * @param context   Context in which to fetch User object, Optional
 */
- (User *)currentUserInContext:(NSManagedObjectContext *)context;

@end
