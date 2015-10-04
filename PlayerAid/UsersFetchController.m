//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;
#import "UsersFetchController.h"
#import "User.h"
#import "AuthenticatedServerCommunicationController.h"
#import "AlertFactory.h"

static const CGFloat kRetryShortDelay = 3.0;
static const CGFloat kRetryLongDelay = 10.0;


@interface UsersFetchController ()
@property (nonatomic, strong) UIAlertView *blockingAlertView;
@property (nonatomic, assign) BOOL hasBlockingAlertAlreadyBeenShown;
@end


@implementation UsersFetchController

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - Profile update

- (void)fetchUsersProfile:(User *)user
{
  if (user.serverIDValue == [self currentUser].serverIDValue) {
    [self fetchCurrentUserProfile];
    return;
  }
  else {
    [[AuthenticatedServerCommunicationController sharedInstance] getUserWithID:[user.serverID stringValue] completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        [AlertFactory showGenericErrorAlertViewNoRetry];
      }
    }];
  }
}

- (void)fetchCurrentUserProfileUserLinkedWithFacebook:(BOOL)userLinkedWithFacebook
{
  [self fetchCurrentUserProfileFacebookUser:@(userLinkedWithFacebook)];
}

- (void)fetchCurrentUserProfile
{
  [self fetchCurrentUserProfileFacebookUser:nil];
}

- (void)fetchCurrentUserProfileFacebookUser:(nullable NSNumber *)userLinkedWithFacebook
{
  __weak typeof(self) weakSelf = self;
  [[AuthenticatedServerCommunicationController sharedInstance] getCurrentUserCompletion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      if ([weakSelf isFirstTimeUserSynchronization]) {
        [self showBlockingAlertIfItHasNotBeenShown];
        
        // this is the first synchronisation, retry api call soon
        DISPATCH_AFTER(kRetryShortDelay, ^{
          [weakSelf fetchCurrentUserProfile];
        });
      }
      else {
        // subsequent synchronisation, profile is probably up to date anyway, retry api call after longer delay
        DISPATCH_AFTER(kRetryLongDelay, ^{
          [weakSelf fetchCurrentUserProfile];
        });
      }
    }
    else if (!error) {
      [weakSelf dismissBlockingAlertView];
      
      AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
      [weakSelf updateLoggedInUserObjectWithDictionary:(NSDictionary *)responseObject userLinkedWithFacebook:userLinkedWithFacebook];
    }
  }];
}

#pragma mark - Fetching User Object

- (User *)currentUserInContext:(NSManagedObjectContext *)context
{
  NSString *const kLoggedInUserKey = @"loggedInUser";
  if (context) {
    return [User MR_findFirstByAttribute:kLoggedInUserKey withValue:@(YES) inContext:context];
  }
  return [User MR_findFirstByAttribute:kLoggedInUserKey withValue:@(YES)];
}

- (User *)currentUser
{
  return [self currentUserInContext:nil];
}

#pragma mark - Updating User Object

- (void)updateLoggedInUserObjectWithDictionary:(nonnull NSDictionary *)dictionary userLinkedWithFacebook:(nullable NSNumber *)linkedWithFacebook
{
  AssertTrueOrReturn(dictionary.count);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    User *user = [self currentUserInContext:localContext];
    if (!user) {
      user = [User MR_createInContext:localContext];
    }
    [user setLoggedInUserValue:YES];
    
    if (linkedWithFacebook) {
      [user setLinkedWithFacebookValue:linkedWithFacebook.boolValue];
    }
    [user configureFromDictionary:dictionary];
  }];
}

#pragma mark - Blocking alert view handling

- (void)showBlockingAlertIfItHasNotBeenShown
{
  if (!self.hasBlockingAlertAlreadyBeenShown) {
    self.blockingAlertView = [AlertFactory showBlockingFirstSyncFailedAlertView];
    self.hasBlockingAlertAlreadyBeenShown = YES;
  }
}

- (void)dismissBlockingAlertView
{
  [self.blockingAlertView dismissWithClickedButtonIndex:0 animated:YES];
  self.blockingAlertView = nil;
}

- (BOOL)isFirstTimeUserSynchronization
{
  User *user = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"loggedInUser == 1"]];
  BOOL anyUserFound = (user != nil);
  return !anyUserFound;
}

@end
