//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import "IntroViewController.h"
#import "AlertFactory.h"


@interface IntroViewController () <FBLoginViewDelegate>
@property (nonatomic, copy) NSString *userEmail;
@end

@implementation IntroViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addFacebookLoginButton];
}

#pragma mark - Facebook login

- (void)addFacebookLoginButton{
  FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email"]];
  loginView.center = self.view.center;
  loginView.delegate = self;
  [self.view addSubview:loginView];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
  // TODO: Now we can send the Facebook access token to our API (with user email address) and push the new view
}

// callback invoked before loginViewShowingLoggedInUser
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
  
  self.userEmail = [self emailFromUser:user];
}

- (NSString *)emailFromUser:(id<FBGraphUser>)user {
  // it is possible to have a user without registered email address, but we always want to have one
  NSString *email = [user objectForKey:@"email"];
  return (email ? email : [NSString stringWithFormat:@"%@@facebook.com", user.username]);
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
  // TODO: Need to ensure user won't be able to logout from this screen
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
  [AlertFactory showAlertFromFacebookError:error];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
