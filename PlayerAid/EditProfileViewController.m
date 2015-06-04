//
//  PlayerAid
//

#import "EditProfileViewController.h"
#import "NavigationBarButtonsDecorator.h"


static NSString *const kEditProfileXibName = @"EditProfileView";


@interface EditProfileViewController ()

@end


@implementation EditProfileViewController

- (instancetype)init
{
  self = [super initWithNibName:kEditProfileXibName bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Edit Profile";
  [self setupNavigationBarButtons];
}

- (void)setupNavigationBarButtons
{
  NavigationBarButtonsDecorator *navbarDecorator = [NavigationBarButtonsDecorator new];
  [navbarDecorator addCancelButtonToViewController:self withSelector:@selector(dismissViewController)];
  [navbarDecorator addSaveButtonToViewController:self withSelector:@selector(saveProfile)];
}

#pragma mark - 

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveProfile
{
  NOT_IMPLEMENTED_YET_RETURN
}

@end
