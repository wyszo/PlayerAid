//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>
#import "IntroViewController.h"

@interface IntroViewController ()

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
    [self.view addSubview:loginView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
