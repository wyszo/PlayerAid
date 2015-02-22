//
//  PlayerAid
//

#import "UsersController.h"
#import "User.h"
#import "AuthenticatedServerCommunicationController.h"
#import "AlertFactory.h"
#import "DispatchHelper.h"

static const CGFloat kRetryShortDelay = 3.0;
static const CGFloat kRetryLongDelay = 10.0;


@interface UsersController ()
@property (nonatomic, strong) UIAlertView *blockingAlertView;
@property (nonatomic, assign) BOOL hasBlockingAlertAlreadyBeenShown;
@end


@implementation UsersController

+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Profile update

- (void)updateUserProfile
{
  __weak typeof(self) weakSelf = self;
  [[AuthenticatedServerCommunicationController sharedInstance] postUserCompletion:^(NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      if ([weakSelf isFirstTimeUserSynchronization]) {
        [self showBlockingAlertIfItHasNotBeenShown];
        
        // this is the first synchronisation, retry api call soon
        DISPATCH_AFTER(kRetryShortDelay, ^{
          [weakSelf updateUserProfile];
        });
      }
      else {
        // subsequent synchronisation, profile is probably up to date anyway, retry api call after longer delay
        DISPATCH_AFTER(kRetryLongDelay, ^{
          [weakSelf updateUserProfile];
        });
      }
    }
    else if (!error) {
      [weakSelf dismissBlockingAlertView];
      [weakSelf updateLoggedInUserObjectWithDictionary:response.allHeaderFields];
    }
  }];
}

- (void)updateLoggedInUserObjectWithDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    User *user = [User MR_findFirstByAttribute:@"loggedInUser" withValue:@(YES) inContext:localContext];
    if (!user) {
      user = [User MR_createInContext:localContext];
    }
    [user setLoggedInUserValue:YES];
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
  User *user = [User MR_findFirst];
  BOOL anyUserFound = (user != nil);
  return !anyUserFound;
}

@end
