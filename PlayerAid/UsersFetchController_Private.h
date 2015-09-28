//
//  PlayerAid
//

#import "UsersFetchController.h"


@interface UsersFetchController (Private)

/**
 @param linkedWithFacebook  optional - if set, it'll set user's linkedWithFacebook property
 */
- (void)updateLoggedInUserObjectWithDictionary:(nonnull NSDictionary *)dictionary userLinkedWithFacebook:(nullable NSNumber *)linkedWithFacebook;

@end
