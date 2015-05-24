//
//  PlayerAid
//

#import "UsersController.h"
#import "User.h"
#import "AuthenticatedServerCommunicationController.h"
#import "AlertFactory.h"

static const CGFloat kRetryShortDelay = 3.0;
static const CGFloat kRetryLongDelay = 10.0;


@interface UsersController ()
@property (nonatomic, strong) UIAlertView *blockingAlertView;
@property (nonatomic, assign) BOOL hasBlockingAlertAlreadyBeenShown;
@end


@implementation UsersController

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - Profile update

- (void)updateUsersProfile:(User *)user
{
  if (user.serverIDValue == [self currentUser].serverIDValue) {
    [self updateCurrentUserProfile];
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

- (void)updateCurrentUserProfile
{
  __weak typeof(self) weakSelf = self;
  [[AuthenticatedServerCommunicationController sharedInstance] getCurrentUserCompletion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      if ([weakSelf isFirstTimeUserSynchronization]) {
        [self showBlockingAlertIfItHasNotBeenShown];
        
        // this is the first synchronisation, retry api call soon
        DISPATCH_AFTER(kRetryShortDelay, ^{
          [weakSelf updateCurrentUserProfile];
        });
      }
      else {
        // subsequent synchronisation, profile is probably up to date anyway, retry api call after longer delay
        DISPATCH_AFTER(kRetryLongDelay, ^{
          [weakSelf updateCurrentUserProfile];
        });
      }
    }
    else if (!error) {
      [weakSelf dismissBlockingAlertView];
      
      AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
      [weakSelf updateLoggedInUserObjectWithDictionary:(NSDictionary *)responseObject];
    }
  }];
}

- (void)updateLoggedInUserObjectWithDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    User *user = [self currentUserInContext:localContext];
    if (!user) {
      user = [User MR_createInContext:localContext];
    }
    [user setLoggedInUserValue:YES];
    [user configureFromDictionary:dictionary];
  }];
}

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
