//
//  PlayerAid
//

#import "UserManipulationController.h"
#import "UsersFetchController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "AlertFactory.h"

static NSString *const kLifetimeFollowString = @"follow";
static NSString *const kLifetimeUnfollowString = @"unfollow";


@implementation UserManipulationController

#pragma mark - Toggle follow button

- (void)toggleFollowButtonPressedSendRequestUpdateModelForUser:(User *)user completion:(VoidBlockWithError)completion
{
  AssertTrueOrReturn(user);
  AssertTrueOrReturn(!user.loggedInUserValue);
  
  if (![self loggedInUserFollowsUser:user]) {
    [self sendFollowUserNetworkRequestAndUpdateDataModel:user completion:completion];
  }
  else {
    [self sendUnfollowUserNetworkRequestAndUpdateDataModel:user completion:completion];
  }
}

#pragma mark - Auxiliary public methods

- (BOOL)currentUserFollowsUser:(User *)user
{
  AssertTrueOrReturnNil(user);
  
  User *currentUser = [UsersFetchController sharedInstance].currentUser;
  return [currentUser.follows containsObject:user];
}

- (BOOL)loggedInUserFollowsUser:(User *)user
{
  AssertTrueOrReturnNo(user);
  return [[UserManipulationController new] currentUserFollowsUser:user];
}

#pragma mark - Send network request, update model

- (void)sendFollowUserNetworkRequestAndUpdateDataModel:(User *)user completion:(VoidBlockWithError)completion
{
  AssertTrueOrReturn(user);
  [self tw_bindLifetimeTo:kLifetimeFollowString]; // ensuring the object exists until the request returns
  
  [[AuthenticatedServerCommunicationController sharedInstance] followUser:user completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    [self tw_releaseLifetimeDependencyFrom:kLifetimeFollowString];
    
    if (error) {
      // TODO: check if we want a generic alert or a custom one here
      [AlertFactory showGenericErrorAlertView];
      CallBlock(completion, error);
    }
    else {
      [self updateCurrentUserModelAddFollowedUser:user];
      CallBlock(completion, nil);
    }
  }];
}

- (void)sendUnfollowUserNetworkRequestAndUpdateDataModel:(User *)user completion:(VoidBlockWithError)completion
{
  AssertTrueOrReturn(user);
  [self tw_bindLifetimeTo:kLifetimeUnfollowString]; // ensuring the object exists until the request returns
  
  [[AuthenticatedServerCommunicationController sharedInstance] unfollowUser:user completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    [self tw_releaseLifetimeDependencyFrom:kLifetimeUnfollowString];
    
    if (error) {
      // TODO: check if we want a generic alert or a custom one here
      [AlertFactory showGenericErrorAlertView];
      CallBlock(completion, error);
    }
    else {
      [self updateCurrentUserModelRemoveFollowedUser:user];
      CallBlock(completion, nil);
    }
  }];
}

#pragma mark - Private

- (void)updateCurrentUserModelAddFollowedUser:(User *)user
{
  [self performSelectorAndSaveOnLoggedInUser:@selector(addFollowsObject:) withUserObject:user];
}

- (void)updateCurrentUserModelRemoveFollowedUser:(User *)user
{
  [self performSelectorAndSaveOnLoggedInUser:@selector(removeFollowsObject:) withUserObject:user];
}

- (void)performSelectorAndSaveOnLoggedInUser:(SEL)selector withUserObject:(User *)user
{
  AssertTrueOrReturn(user);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    User *loggedInUserInContext = [[UsersFetchController sharedInstance] currentUserInContext:localContext];
    User *followedUserInContext = [user MR_inContext:localContext];
    
    SuppressPerformSelectorLeakWarning(
      [loggedInUserInContext performSelector:selector withObject:followedUserInContext];
    );
  }];
}

@end
