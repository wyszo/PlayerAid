//
//  PlayerAid
//

#import "EditProfileViewController.h"
#import "NavigationBarButtonsDecorator.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"


static NSString *const kEditProfileXibName = @"EditProfileView";


@interface EditProfileViewController ()

@property (nonatomic, weak) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

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
  self.view.backgroundColor = [ColorsHelper editProfileViewBackgroundColor];
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
  [self.avatarImageView styleAsAvatarThinBorder];
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
