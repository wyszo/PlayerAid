//
//  PlayerAid
//

#import "EditProfileViewController.h"
#import "UITextView+Placeholder.h"
#import "NavigationBarButtonsDecorator.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"
#import "AlertControllerFactory.h"
#import "AlertFactory.h"
#import "AuthenticatedServerCommunicationController.h"
#import "UsersFetchController_Private.h"


static const BOOL HideRefreshFromFacebookButton = YES;

static NSString *const kEditProfileXibName = @"EditProfileView";
static const CGFloat kTextViewBorderWidth = 1.0f;
static const CGFloat kFacebookButtonBorderWidth = 1.0f;
static const CGFloat kTextViewLeftAndRightPadding = 12.0f;
static const CGFloat kTextViewTopPadding = 12.0f;
static const CGFloat kFacebookButtonCornerRadius = 8.0f;
static const CGFloat kAboutMeKeyboardScrollViewOffset = 180.0f;
static const NSInteger kPlayerNameMaxNumberOfCharacters = 150;
static const NSInteger kAboutMeCharacterLimit = 150;


@interface EditProfileViewController ()

@property (nonatomic, weak) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIButton *refreshFacebookDetailsButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeCharactersLabel;

@end


@implementation EditProfileViewController

#pragma mark - View Lifecycle and styling

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
  [self setupTextViewDelegates];
  [self setupTapGestureRecognizer];
  [self populateDataFromUserObject];
  
  self.refreshFacebookDetailsButton.hidden = HideRefreshFromFacebookButton;
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

- (void)setupTextViewDelegates
{
  [self setupNameTextViewDelegateWithTextMaxLength:kPlayerNameMaxNumberOfCharacters];
  [self setupAboutMeTextViewDelegateWithTextMaxLength:kAboutMeCharacterLimit];
  [self setupAboutMeCharacterLimitLabelTextViewDelegate];
}

- (void)setupTapGestureRecognizer
{
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
  [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)styleAvatar
{
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

  [self.refreshFacebookDetailsButton setTitleColor:facebookColor forState:UIControlStateNormal];
  [self.refreshFacebookDetailsButton tw_addBorderWithWidth:kFacebookButtonBorderWidth color:facebookColor];
  [self.refreshFacebookDetailsButton tw_setCornerRadius:kFacebookButtonCornerRadius];
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
  self.bioTextView.placeholder = @"Introduce yourself to the PlayerAid community. Have some fun. 😜 p.s. lots of people like to add their other social media handles!";
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

#pragma mark - TextView Delegates

- (void)setupNameTextViewDelegateWithTextMaxLength:(NSInteger)textViewMaxLength
{
  UITextView *textView = self.nameTextView;
  
  TWTextViewWithMaxLengthDelegate *delegate = [[TWTextViewWithMaxLengthDelegate alloc] initWithMaxLength:textViewMaxLength attachToTextView:textView];
  delegate.resignsFirstResponderOnPressingReturn = YES;
  [delegate tw_bindLifetimeTo:textView];
  textView.delegate = delegate;
}

- (void)setupAboutMeTextViewDelegateWithTextMaxLength:(NSInteger)textViewMaxLength
{
  UITextView *textView = self.bioTextView;
  TWTextViewWithMaxLengthDelegate *delegate = [[TWTextViewWithMaxLengthDelegate alloc] initWithMaxLength:textViewMaxLength attachToTextView:textView];
  
  defineWeakSelf();
  delegate.textViewDidBeginEditing = ^() {
    [weakSelf.scrollView setContentOffset:CGPointMake(0, kAboutMeKeyboardScrollViewOffset) animated:YES];
  };
  delegate.textViewDidEndEditing = ^() {
    [weakSelf.scrollView setContentOffset:CGPointZero animated:YES];
  };
  
  [delegate tw_bindLifetimeTo:textView];
  textView.delegate = delegate;
}

- (void)setupAboutMeCharacterLimitLabelTextViewDelegate
{
  AssertTrueOr(self.bioTextView.delegate != nil && @"This method will chain a new delegate with a previous one", ;);
  TWTextViewWithCharacterLimitLabelDelegate *delegate = [[TWTextViewWithCharacterLimitLabelDelegate alloc] initWithCharacterLimitLabel:self.aboutMeCharactersLabel maxLength:kAboutMeCharacterLimit attachToTextView:self.bioTextView];
  delegate.overCharacterLimitValueChanged = ^(BOOL overCharacterLimitValue) {
    self.navigationItem.rightBarButtonItem.enabled = !overCharacterLimitValue;
  };
}

#pragma mark - Network communication

- (void)makeUpdateAvatarFromFacebookNetworkRequest
{
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] updateUserAvatarFromFacebookCompletion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [AlertFactory showUpdateAvatarFromFacebookFailureAlertView];
    }
    else {
      AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
      [[UsersFetchController sharedInstance] updateLoggedInUserObjectWithDictionary:responseObject];
      [weakSelf populateDataFromUserObject];
    }
  }];
}

- (void)saveProfile
{
  NOT_IMPLEMENTED_YET_RETURN
}

#pragma mark - Other Methods

- (void)populateDataFromUserObject
{
  self.nameTextView.text = self.user.name;
  self.bioTextView.text = self.user.userDescription;
  [self.user placeAvatarInImageView:self.avatarImageView];
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backgroundTapped
{
  [self.bioTextView resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)avatarOverlayButtonPressed:(id)sender
{
  defineWeakSelf();
  UIViewController *alert = [AlertControllerFactory editProfilePhotoActionControllerFacebookAction:^{
    [weakSelf makeUpdateAvatarFromFacebookNetworkRequest];
  }
  chooseFromLibraryAction:^{
    NOT_IMPLEMENTED_YET_RETURN
  }
  takePhotoAction:^{
    NOT_IMPLEMENTED_YET_RETURN
  }];
  [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)facebookRefreshButtonPressed:(id)sender
{
  NOT_IMPLEMENTED_YET_RETURN
}

@end
