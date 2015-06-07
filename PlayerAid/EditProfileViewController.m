//
//  PlayerAid
//

#import "EditProfileViewController.h"
#import "NavigationBarButtonsDecorator.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"


  #import <UIView+FLKAutoLayout.h>


static NSString *const kEditProfileXibName = @"EditProfileView";
static const CGFloat kTextViewBorderWidth = 1.0f;
static const CGFloat kTextViewLeftAndRightPadding = 12.0f;
static const CGFloat kTextViewTopPadding = 12.0f;


@interface EditProfileViewController ()

@property (nonatomic, weak) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
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
  [self styleAvatar];
  [self styleLabels];
  [self styleTextViews];
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

  self.nameLabel.textColor = [ColorsHelper playerAidBlueColor];
  self.nameLabel.alpha = 0.8;
}

- (void)styleTextViews
{
  [self.nameTextView tw_addBorderWithWidth:kTextViewBorderWidth color:[ColorsHelper editProfileSubviewsBorderColor]];
  [self.nameTextView tw_setLeftAndRightPadding:kTextViewLeftAndRightPadding];
  [self.nameTextView tw_setTopPadding:kTextViewTopPadding];
  
  [self addPlaceholderViewToTextView:self.nameTextView];
  
  // that should be a placeholder view!!!
//  self.nameTextView.text = @"Player Name";
}

- (void)addPlaceholderViewToTextView:(UITextView *)textView
{
  // Beware: that method changes both textView and view hierarchy in general!!
  
  AssertTrueOrReturn(textView);
  // TODO: extract this logic to CommonLib!!!
  
  // 1. create a new textView and attach to parent
  // zle - to powinno byc tylko zwyklym UILabelem... - i powinno byc na wierzchu view hierarchy, nie pod spodem!
  UITextView *placeholderTextView = [[UITextView alloc] init];
  UIView *parent = textView.superview;
  AssertTrueOrReturn(parent && @"Text view has to be attached to view hierarchy already to add a placeholder");
  [parent insertSubview:placeholderTextView belowSubview:textView];
  
  // 2. add constraints
  [placeholderTextView constrainWidthToView:textView predicate:nil];
  [placeholderTextView constrainHeightToView:textView predicate:nil];
  [placeholderTextView alignCenterWithView:textView];
  
  // 3. set properties - insets, font
  
  placeholderTextView.font = textView.font;
  placeholderTextView.textContainerInset = textView.textContainerInset;
  
  // temp
//  placeholderTextView.backgroundColor = [UIColor redColor];
//  textView.alpha = 0.5f;
  placeholderTextView.text = @"Placeholder text";
  placeholderTextView.backgroundColor = textView.backgroundColor;
  placeholderTextView.textColor = [ColorsHelper editProfileSubviewsBorderColor]; // TODO: parametrize this
  textView.backgroundColor = [UIColor clearColor];
  
  // 4. add a delegate reacting to no text in a textView
  
  // Ugly and unexpected - textView gets a delegate assigned here!
  // We can observe for a property change to ensure a user doesn't assign a new delegate on top of an existing one
  
  NSInteger maxLength = 100; // What should we limit it to????
  [self setupTextViewDelegate:textView hidingPlaceholderTextView:placeholderTextView textViewMaxLength:maxLength];
  
  // very ugly!
  ((TWTextViewWithMaxLengthDelegate *)textView.delegate).textDidChange(textView.text);
}

- (void)setupTextViewDelegate:(UITextView *)textView hidingPlaceholderTextView:(UITextView *)placeholderTextView textViewMaxLength:(NSInteger)textViewMaxLength
{
  AssertTrueOrReturn(textView);
  AssertTrueOrReturn(placeholderTextView);
  
  TWTextViewWithMaxLengthDelegate *delegate = [[TWTextViewWithMaxLengthDelegate alloc] initWithMaxLength:textViewMaxLength attachToTextView:textView];
  delegate.resignsFirstResponderOnPressingReturn = YES;
  
  __weak UITextView *weakPlaceholderTextView = placeholderTextView;
  delegate.textDidChange = ^(NSString *text) {
    // it shouldn't be hidden - it shoud change text...
    BOOL shouldShowPlaceholder = !(text.length > 0);
    
    if (shouldShowPlaceholder) {
      weakPlaceholderTextView.text = @"Placeholder text"; // TODO: parametrize this!!
    }
    else {
      weakPlaceholderTextView.text = @"";
    }
  };
  textView.delegate = delegate;
  [delegate tw_bindLifetimeTo:textView];
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
