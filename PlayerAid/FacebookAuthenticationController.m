//
//  PlayerAid
//

#import "FacebookAuthenticationController.h"
#import "FBSession.h"


@interface FacebookAuthenticationController () <FBLoginViewDelegate>
@property (nonatomic, copy) void (^completionBlock)(id<FBGraphUser> user, NSError *error);
@property (nonatomic, strong) id<FBGraphUser> user;
@property (nonatomic, assign) BOOL loggedIn;
@end

@implementation FacebookAuthenticationController

#pragma mark - Singleton

/* Technical debt: could easily avoid making a singleton here! */
SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - Public interface

+ (FBLoginView *)facebookLoginViewWithLoginCompletion:(void (^)(id<FBGraphUser> user, NSError *error))completion
{
  ((FacebookAuthenticationController *)self.sharedInstance).completionBlock = completion;
  
  FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email"]];
  loginView.delegate = self.sharedInstance;
  return loginView;
}

+ (void)logout
{
  [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark - FBLoginViewDelegate

// depending on the scenario, either this method will be called first or loginViewFetchedUserInfo:user:
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
  self.loggedIn = YES;
  [self invokeCompletionBlockIfUserLoggedInAndUserInfoFetched];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
  if (self.user == user) {
    return; // delegate method called more than once, ignore
  }
 
  AssertTrueOrReturn(user);
  self.user = user;
  [self invokeCompletionBlockIfUserLoggedInAndUserInfoFetched];
}

- (void)invokeCompletionBlockIfUserLoggedInAndUserInfoFetched
{
  if (self.completionBlock && self.user && self.loggedIn) {
    AssertTrueOrReturn(self.user);
    self.completionBlock(self.user, nil);
  }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
  // TODO: Need to ensure user won't be able to logout from the intro screen...
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
  if (self.completionBlock) {
    self.completionBlock(nil, error);
  }
}

@end