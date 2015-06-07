//
//  PlayerAid
//

#import "EditProfileViewController.h"
#import "UITextView+Placeholder.h"
#import "NavigationBarButtonsDecorator.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"


static NSString *const kEditProfileXibName = @"EditProfileView";
static const CGFloat kTextViewBorderWidth = 1.0f;
static const CGFloat kFacebookButtonBorderWidth = 1.0f;
static const CGFloat kTextViewLeftAndRightPadding = 12.0f;
static const CGFloat kTextViewTopPadding = 12.0f;
static const CGFloat kFacebookButtonCornerRadius = 8.0f;
static const NSInteger kPlayerNameMaxNumberOfCharacters = 150;


@interface EditProfileViewController ()

@property (nonatomic, weak) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIButton *facebookDetailsButton;

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
  [self styleAvatar];
  [self styleLabels];
  [self styleFacebookButton];
  [self styleTextViews];
  [self fillTextViews];
  [self setupTextViewDelegate:self.nameTextView textViewMaxLength:kPlayerNameMaxNumberOfCharacters]; 
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

- (void)styleAvatar
{
  [self.user placeAvatarInImageView:self.avatarImageView];
  [self.avatarImageView styleAsAvatarThinBorder];
}

- (void)styleLabels
{
  self.editLabel.textColor = [ColorsHelper playerAidBlueColor];

  [self styleTextViewDescriptionLabel:self.nameLabel];
  [self styleTextViewDescriptionLabel:self.aboutMeLabel];
}

- (void)styleFacebookButton
{
  UIColor *facebookColor = [ColorsHelper editProfileFacebookButtonColor];

  [self.facebookDetailsButton setTitleColor:facebookColor forState:UIControlStateNormal];
  [self.facebookDetailsButton tw_addBorderWithWidth:kFacebookButtonBorderWidth color:facebookColor];
  [self.facebookDetailsButton tw_setCornerRadius:kFacebookButtonCornerRadius];
}

- (void)styleTextViewDescriptionLabel:(UILabel *)label
{
  AssertTrueOrReturn(label);
  
  label.textColor = [ColorsHelper playerAidBlueColor];
  label.alpha = 0.8f;
}

- (void)styleTextViews
{
  [self styleTextView:self.nameTextView];
  [self limitPlayerNameTextViewToOneLine];
  self.nameTextView.placeholder = @"Player Name";
  
  [self styleTextView:self.bioTextView];
  self.bioTextView.placeholder = @"Enter Bio";
}

- (void)styleTextView:(UITextView *)textView
{
  AssertTrueOrReturn(textView);
  
  [textView tw_addBorderWithWidth:kTextViewBorderWidth color:[ColorsHelper editProfileSubviewsBorderColor]];
  [textView tw_setLeftAndRightPadding:kTextViewLeftAndRightPadding];
  [textView tw_setTopPadding:kTextViewTopPadding];
}

- (void)limitPlayerNameTextViewToOneLine
{
  self.nameTextView.textContainer.maximumNumberOfLines = 1;
  self.nameTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)fillTextViews
{
  self.nameTextView.text = self.user.name;
  self.bioTextView.text = self.user.userDescription;
}

- (void)setupTextViewDelegate:(UITextView *)textView textViewMaxLength:(NSInteger)textViewMaxLength
{
  AssertTrueOrReturn(textView);
  
  TWTextViewWithMaxLengthDelegate *delegate = [[TWTextViewWithMaxLengthDelegate alloc] initWithMaxLength:textViewMaxLength attachToTextView:textView];
  delegate.resignsFirstResponderOnPressingReturn = YES;
  [delegate tw_bindLifetimeTo:textView];
  textView.delegate = delegate;
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

- (IBAction)facebookRefreshButtonPressed:(id)sender
{
  NOT_IMPLEMENTED_YET_RETURN
}

@end
