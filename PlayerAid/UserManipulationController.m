//
//  PlayerAid
//

#import "UserManipulationController.h"
#import "UsersFetchController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "AlertFactory.h"

static NSString *const kLifetimeStaticString = @"static";


@implementation UserManipulationController

#pragma mark - Public

- (void)sendFollowUserNetworkRequestAndUpdateDataModel:(User *)user
{
  AssertTrueOrReturn(user);
  [self tw_bindLifetimeTo:kLifetimeStaticString]; // ensuring the object exists until the request returns
  
  [[AuthenticatedServerCommunicationController sharedInstance] followUser:user completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    [self tw_releaseLifetimeDependencyFrom:kLifetimeStaticString];
    
    if (error) {
      // TODO: check if we want a generic alert or a custom one here
      [AlertFactory showGenericErrorAlertView];
    }
    else {
      [self updateCurrentUserModelAddFollowedUser:user];
    }
  }];
}

#pragma mark - Private

- (void)updateCurrentUserModelAddFollowedUser:(User *)user
{
  AssertTrueOrReturn(user);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    User *loggedInUserInContext = [[UsersFetchController sharedInstance] currentUserInContext:localContext];
    User *followedUserInContext = [user MR_inContext:localContext];
    [loggedInUserInContext addFollowsObject:followedUserInContext];
  }];
}

@end
