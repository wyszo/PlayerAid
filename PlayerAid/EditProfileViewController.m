//
//  PlayerAid
//

@import FBSDKCoreKit;
@import FDTake;
@import KZAsserts;
@import TWCommonLib;
#import "EditProfileViewController.h"
#import "UITextView+Placeholder.h"
#import "NavigationBarButtonsDecorator.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"
#import "AlertControllerFactory.h"
#import "AlertFactory.h"
#import "AuthenticatedServerCommunicationController.h"
#import "UsersFetchController_Private.h"
#import "MediaPickerHelper.h"

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


@interface EditProfileViewController () <FDTakeDelegate, YCameraViewControllerDelegate>

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
@property (strong, nonatomic) FDTakeController *mediaController;

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
  self.editLabel.textColor = [ColorsHelper editProfileTextLabelsColor];

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

- (void)styleTextViewDescriptionLabel:(UILabel *)label {
  AssertTrueOrReturn(label);
  
  label.textColor = [ColorsHelper editProfileTextLabelsColor];
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
  textView.returnKeyType = UIReturnKeyDone;
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
  
  defineWeakSelf();
  delegate.textDidChange = ^(NSString *text) {
    [weakSelf updateNavbarSaveButtonState];
  };
  delegate.resignsFirstResponderOnPressingReturn = YES;
  [delegate tw_bindLifetimeTo:textView];
  
  textView.delegate = delegate;
}

- (void)setupAboutMeTextViewDelegateWithTextMaxLength:(NSInteger)textViewMaxLength
{
  UITextView *textView = self.bioTextView;
  TWTextViewWithMaxLengthDelegate *delegate = [[TWTextViewWithMaxLengthDelegate alloc] initWithMaxLength:textViewMaxLength attachToTextView:textView];
  delegate.resignsFirstResponderOnPressingReturn = YES;
  
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
  
  defineWeakSelf();
  delegate.overCharacterLimitValueChanged = ^(BOOL overCharacterLimitValue) {
    [weakSelf updateNavbarSaveButtonStateWithOverCharacterLimitValue:overCharacterLimitValue];
  };
}

#pragma mark - Network communication

- (void)makeUpdateAvatarFromFacebookNetworkRequest
{
  NSString *facebookToken = [FBSDKAccessToken currentAccessToken].tokenString;
  AssertTrueOrReturn(facebookToken.length);
  
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] updateUserAvatarFromFacebookWithAccessToken:facebookToken completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [AlertFactory showUpdateAvatarFromFacebookFailureAlertView];
    }
    else {
      [weakSelf saveCurrentUserFromUserDictionary:responseObject];
    }
  }];
}

- (void)saveProfile
{
  NSString *userName = self.nameTextView.text;
  AssertTrueOrReturn(userName.length > 0);
  
  [[AuthenticatedServerCommunicationController sharedInstance] saveUserProfileWithName:userName description:self.bioTextView.text completion:[self saveAvatarOrProfileCompletionBlock]];
}

#pragma mark - NavigationBar button states

- (void)updateNavbarSaveButtonStateWithOverCharacterLimitValue:(BOOL)overCharacterLimit
{
  self.navigationItem.rightBarButtonItem.enabled = (!overCharacterLimit && self.playerNameNotEmpty);
}

- (void)updateNavbarSaveButtonState
{
  id delegate = self.bioTextView.delegate;
  AssertTrueOrReturn([delegate isKindOfClass:[TWTextViewWithCharacterLimitLabelDelegate class]]);
  TWTextViewWithCharacterLimitLabelDelegate *textViewDelegate = delegate;
  
  [self updateNavbarSaveButtonStateWithOverCharacterLimitValue:textViewDelegate.overCharacterLimit];
}

#pragma mark - Populating UI from model

- (void)populateDataFromUserObject
{
  self.nameTextView.text = self.user.name;
  self.bioTextView.text = self.user.userDescription;
  [self.user placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSizeLarge];
}

#pragma mark - Other Methods

- (void)saveCurrentUserFromUserDictionary:(NSDictionary *)userDictionary
{
  AssertTrueOrReturn(userDictionary.count);
  [[UsersFetchController sharedInstance] updateLoggedInUserObjectWithDictionary:userDictionary userLinkedWithFacebook:nil];
  [self populateDataFromUserObject];
}

- (BOOL)playerNameNotEmpty
{
  return (self.nameTextView.text.length != 0);
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
  VoidBlock updatePhotoFromFacebookAction = ^() {
    [weakSelf makeUpdateAvatarFromFacebookNetworkRequest];
  };
  if (!self.user.linkedWithFacebookValue) {
    // TODO: we sholud check a FBSession object instead!
    // hide 'Update photo from Facebook' actionSheet option
    updatePhotoFromFacebookAction = nil;
  }
  
  UIViewController *alert = [AlertControllerFactory editProfilePhotoActionControllerFacebookAction:updatePhotoFromFacebookAction chooseFromLibraryAction:^{
    [weakSelf.mediaController chooseFromLibrary];
  }
  takePhotoAction:^{
    [weakSelf.mediaController takePhoto];
  }];
  [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)facebookRefreshButtonPressed:(id)sender
{
  // This button is not visible atm
  NOT_IMPLEMENTED_YET_RETURN
}

#pragma mark - FDTakeDelegate, YCameraViewControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
  AssertTrueOrReturn(photo);
  [[AuthenticatedServerCommunicationController sharedInstance] saveUserAvatarPicture:photo completion:[self saveAvatarOrProfileCompletionBlock]];
}

- (void)yCameraController:(YCameraViewController *)cameraController didFinishPickingImage:(UIImage *)image
{
  AssertTrueOrReturn(image);
  [[AuthenticatedServerCommunicationController sharedInstance] saveUserAvatarPicture:image completion:[self saveAvatarOrProfileCompletionBlock]];
}

#pragma mark - Save avatar completion

- (NetworkResponseBlock)saveAvatarOrProfileCompletionBlock
{
  defineWeakSelf();
  void (^completion)(NSHTTPURLResponse *response, id responseObject, NSError *error) = ^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [AlertFactory showOKAlertViewWithMessage:@"Failed to upload, please try again"];
    }
    else {
      AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
      [weakSelf saveCurrentUserFromUserDictionary:responseObject];
      
      CallBlock(weakSelf.didUpdateUserProfileBlock, nil);
      [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }
  };
  return completion;
}

#pragma mark - Lazy initalization
// TODO: this should be injected as a dependency

- (FDTakeController *)mediaController
{
  if (!_mediaController) {
    _mediaController = [MediaPickerHelper fdTakeControllerWithDelegate:self viewControllerForPresentingImagePickerController:self.navigationController];
    
    defineWeakSelf();
    _mediaController.presentCustomPhotoCaptureViewBlock = ^() {
      [MediaPickerHelper takePictureUsingYCameraViewWithDelegate:weakSelf fromViewController:weakSelf.navigationController];
    };
  }
  return _mediaController;
}

@end
