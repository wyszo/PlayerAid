//
//  PlayerAid
//

#import "EditProfileViewController.h"
#import "NavigationBarButtonsDecorator.h"
#import "UIImageView+AvatarStyling.h"


static NSString *const kEditProfileXibName = @"EditProfileView";


@interface EditProfileViewController ()

@property (nonatomic, weak) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end


@implementation EditProfileViewController

- (instancetype)initWithUser:(User *)user
{
  AssertTrueOrReturnNil(user);
  
  self = [super initWithNibName:kEditProfileXibName bundle:nil];
  if (self) {
    _user = user;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupViewController];
  [self setupNavigationBarButtons];
  [self setupAvatar];
}

- (void)setupViewController
{
  [self tw_setNavbarDoesNotCoverTheView];
  self.title = @"Edit Profile";
}

- (void)setupNavigationBarButtons
{
  NavigationBarButtonsDecorator *navbarDecorator = [NavigationBarButtonsDecorator new];
  [navbarDecorator addCancelButtonToViewController:self withSelector:@selector(dismissViewController)];
  [navbarDecorator addSaveButtonToViewController:self withSelector:@selector(saveProfile)];
}

- (void)setupAvatar
{
  [self.user placeAvatarInImageView:self.avatarImageView];
  [self.avatarImageView styleAsAvatarNoBorder];
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

#pragma mark - IBActions

- (IBAction)avatarOverlayButtonPressed:(id)sender
{
  NOT_IMPLEMENTED_YET_RETURN
}

@end
