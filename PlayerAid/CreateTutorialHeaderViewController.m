//
//  PlayerAid
//

#import "CreateTutorialHeaderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabBarHelper.h"
#import "AlertFactory.h"
#import "Section.h"
#import "GradientHelper.h"
#import "FDTakeController+WhiteStatusbar.h"
#import "MediaPickerHelper.h"
#import "SectionLabelContainer.h"
#import "NSString+Trimming.h"
#import "YCameraViewStandardDelegateObject.h"
#import "ColorsHelper.h"


static const NSInteger kMaxTitleLength = 60;
static const NSInteger kLeftRightContentInset = 10;
static const CGFloat kTitleTextViewCornerRadius = 6.0f;


@interface CreateTutorialHeaderViewController () <UIActionSheetDelegate, FDTakeDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextField *titlePlaceholderTextView;
@property (strong, nonatomic) TWTextViewWithMaxLengthDelegate *titleTextViewDelegate;

@property (weak, nonatomic) IBOutlet UIButton *editCoverPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *pickACategoryButton;
@property (weak, nonatomic) IBOutlet UIView *grayOverlayView;
@property (weak, nonatomic) IBOutlet UIView *gradientOverlayView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet SectionLabelContainer *sectionLabelContainer;
@property (weak, nonatomic) IBOutlet UIButton *sectionLabelContainerButton;

@property (strong, nonatomic) NSArray *actionSheetSections;
@property (strong, nonatomic) Section *selectedSection;

@property (strong, nonatomic) FDTakeController *mediaController;
@property (strong, nonatomic) YCameraViewStandardDelegateObject *yCameraDelegate;

@end


@implementation CreateTutorialHeaderViewController

- (instancetype)init
{
  self = [super initWithNibName:@"CreateTutorialHeaderView" bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setupTitleTextViewDelegate];
  [self styleTitleTextView];
  [self setupEditCoverPhotoBackgroundImageGray];
  [self setupPickACategoryButtonBackgroundImageGray];
  self.grayOverlayView.hidden = YES;
  [self setupSectionLabelContainer];
  [self setupCustomCamera];
}

- (void)setupTitleTextViewDelegate
{
  TWTextViewWithMaxLengthDelegate *delegate = [[TWTextViewWithMaxLengthDelegate alloc] initWithMaxLength:kMaxTitleLength attachToTextView:self.titleTextView];
  delegate.resignsFirstResponderOnPressingReturn = YES;
  
  defineWeakSelf();
  delegate.textDidChange = ^(NSString *text) {
    weakSelf.titlePlaceholderTextView.hidden = (text.length > 0);
  };
  
  self.titleTextViewDelegate = delegate;
}

- (void)styleTitleTextView
{
  [self setTitleTextViewLeftAndRightContentInsets:kLeftRightContentInset];
  [self.titleTextView setCornerRadius:kTitleTextViewCornerRadius];
  [self setTitleTextViewBorderColor:[ColorsHelper createTutorialHeaderElementsBorderColor]];
}

- (void)setTitleTextViewLeftAndRightContentInsets:(NSInteger)leftRightInset
{
  UIEdgeInsets insets = self.titleTextView.textContainerInset;
  self.titleTextView.textContainerInset = UIEdgeInsetsMake(insets.top, leftRightInset, insets.bottom, leftRightInset);
}

- (void)setupCustomCamera
{
  defineWeakSelf();
  self.yCameraDelegate = [YCameraViewStandardDelegateObject new];
  self.yCameraDelegate.cameraDidFinishPickingImageBlock = ^(UIImage *image) {
    [weakSelf setEditCoverPhoto:image];
  };
}

- (void)setupSectionLabelContainer
{
  self.sectionLabelContainer.titleLabel.text = @"Pick a Category";
  self.sectionLabelContainer.hidden = YES;
}

- (void)setupEditCoverPhotoBackgroundImageWhite
{
  return [self setBorderWithImageNamed:@"RoundedRectangleWhite" forButton:self.editCoverPhotoButton];
}

- (void)setupEditCoverPhotoBackgroundImageGray
{
  return [self setBorderWithImageNamed:@"RoundedRectangleGray" forButton:self.editCoverPhotoButton];
}

- (void)setupPickACategoryButtonBackgroundImageWhite
{
    return [self setBorderWithImageNamed:@"RoundedRectangleWhite" forButton:self.pickACategoryButton];
}

- (void)setupPickACategoryButtonBackgroundImageGray
{
  return [self setBorderWithImageNamed:@"RoundedRectangleGray" forButton:self.pickACategoryButton];
}

- (void)setupTitleTextViewTextAndBorderWhite
{
  self.titleTextView.textColor = [UIColor whiteColor];
  [self setTitleTextViewBorderColor:[UIColor whiteColor]];
}

- (void)setTitleTextViewBorderColor:(UIColor *)color
{
  AssertTrueOrReturn(color);
  [self.titleTextView addBorderWithWidth:1.0f color:color];
}

- (void)setBorderWithImageNamed:(NSString *)imageName forButton:(UIButton *)button
{
  AssertTrueOrReturn(button);
  AssertTrueOrReturn(imageName.length);
  CGFloat inset = 15.0f;
  
  UIImage *image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
  [button setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setupAndShowOverlays
{
  [self setupGradientOverlay];
  self.grayOverlayView.hidden = NO;
}

- (void)updateSubviewsColoursToWhite
{
  [self setupEditCoverPhotoBackgroundImageWhite];
  [self.editCoverPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  [self setupPickACategoryButtonBackgroundImageWhite];
  [self.pickACategoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  [self setupTitleTextViewTextAndBorderWhite];
}

// this should be part of UIView, not a view controller..
- (void)setupGradientOverlay
{
  if (self.gradientLayer) {
    return;
  }
  self.gradientOverlayView.alpha = 0.8;
  self.gradientLayer = [GradientHelper addGradientLayerToView:self.gradientOverlayView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  self.gradientLayer.frame = self.gradientOverlayView.bounds;
}

- (void)hidePickACategoryButtonShowSectionLabel
{
  self.sectionLabelContainer.hidden = NO;
  self.sectionLabelContainerButton.hidden = NO;
  
  self.pickACategoryButton.hidden = YES;
}

#pragma mark - IBActions

- (IBAction)editCoverPhoto:(id)sender
{
  AssertTrueOrReturn(self.mediaController);
  [self.mediaController takePhotoOrChooseFromLibrary];
}

- (IBAction)pickACategory:(id)sender
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
  
  self.actionSheetSections = [Section MR_findAll];
  AssertTrueOrReturn(self.actionSheetSections.count);
  
  for (Section *section in self.actionSheetSections) {
    [actionSheet addButtonWithTitle:section.displayName];
  }

  UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  [actionSheet showInView:window];
}

- (BOOL)validateTutorialDataCompleteShowErrorAlerts
{
  BOOL titleSet = (self.title.length > 0);
  BOOL sectionSet = (self.selectedSection != nil);
  BOOL backgroundImageSet = (self.backgroundImageView.image != nil);
  
  int numberOfFilledPiecesOfInfo = (titleSet ? 1 : 0) + (sectionSet ? 1 : 0) + (backgroundImageSet ? 1 : 0);
  
  if (numberOfFilledPiecesOfInfo < 2) {
    [AlertFactory showCreateTutorialFillTutorialDetails];
    return NO;
  }
  
  if (!titleSet) {
    [AlertFactory showCreateTutorialNoTitleAlertView];
    return NO;
  }
  
  if (!sectionSet) {
    [AlertFactory showCreateTutorialNoSectionSelectedAlertView];
    return NO;
  }

  if (!backgroundImageSet) {
    [AlertFactory showCreateTutorialNoImageAlertView];
    return NO;
  }
  
  return YES;
}

#pragma mark - Accessors

- (NSString *)title
{
  return [self.titleTextView.text stringByTrimmingWhitespaceAndNewline];
}

#pragma mark - Auxiliary methods

- (BOOL)hasAnyData
{
  return (self.title.length || self.selectedSection || self.backgroundImageView.image);
}

#pragma mark - Edit Cover photo handling

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
  [self setEditCoverPhoto:photo];
}

- (void)setEditCoverPhoto:(UIImage *)photo
{
  AssertTrueOrReturn(photo);
  self.backgroundImageView.image = photo;
  [self setupAndShowOverlays];
  [self updateSubviewsColoursToWhite];
  
  if (self.selectedSection) {
    [self hidePickACategoryButtonShowSectionLabel];
  }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != actionSheet.cancelButtonIndex && buttonIndex != actionSheet.destructiveButtonIndex) {
    AssertTrueOrReturn(buttonIndex > 0);
    NSInteger actionSheetSectionIndex = buttonIndex - 1; // cancelButtonIndex equals 0
    self.selectedSection = self.actionSheetSections[actionSheetSectionIndex];

    NSString *title = self.selectedSection.displayName;
    [self.pickACategoryButton setTitle:title forState:UIControlStateNormal];
    self.sectionLabelContainer.titleLabel.text = title;
    
    if (self.backgroundImageView.image) {
      [self hidePickACategoryButtonShowSectionLabel];
    }
  }
}

#pragma mark - Lazy initalization

- (FDTakeController *)mediaController
{
  if (!_mediaController) {
    _mediaController = [MediaPickerHelper fdTakeControllerWithDelegate:self viewControllerForPresentingImagePickerController:self.imagePickerPresentingViewController];
    
    defineWeakSelf();
    _mediaController.presentCustomPhotoCaptureViewBlock = ^() {
      [MediaPickerHelper takePictureUsingYCameraViewWithDelegate:weakSelf.yCameraDelegate fromViewController:weakSelf.imagePickerPresentingViewController];
    };
  }
  return _mediaController;
}

@end
