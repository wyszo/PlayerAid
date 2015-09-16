//
//  PlayerAid
//

#import "LoginViewController.h"
#import "ColorsHelper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Log In";
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  [self skinView];
  [self setupFacebookLoginButton];
}

- (void)skinView
{
  self.view.backgroundColor = [ColorsHelper loginLogInLightBlueBackgroundColor];
}

- (void)setupFacebookLoginButton
{
  NOT_IMPLEMENTED_YET_RETURN
}

@end
