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


static const CGSize originalViewSize = { 320.0f, 226.0f };


@interface CreateTutorialHeaderViewController () <UITextFieldDelegate, UIActionSheetDelegate, FDTakeDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickACategoryButton;
@property (weak, nonatomic) IBOutlet UIView *gradientOverlayView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong, nonatomic) NSArray *actionSheetSections;
@property (strong, nonatomic) Section *selectedSection;

@property (strong, nonatomic) FDTakeController *mediaController;

@end


@implementation CreateTutorialHeaderViewController

- (instancetype)init
{
  self = [super initWithNibName:@"CreateTutorialHeaderView" bundle:nil];
  if (self) {
  }
  return self;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
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
  if (!self.titleTextField.text.length) {
    [AlertFactory showCreateTutorialNoTitleAlertView];
    return NO;
  }
  
  if (!self.selectedSection) {
    [AlertFactory showCreateTutorialNoSectionSelectedAlertView];
    return NO;
  }
  
  if (!self.backgroundImageView.image) {
    [AlertFactory showCreateTutorialNoImageAlertView];
    return NO;
  }
  
  return YES;
}

#pragma mark - Accessors

- (NSString *)title
{
  return self.titleTextField.text;
}

#pragma mark - FDTakeController

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
  AssertTrueOrReturn(photo);
  self.backgroundImageView.image = photo;
  [self setupGradientOverlay];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != actionSheet.cancelButtonIndex && buttonIndex != actionSheet.destructiveButtonIndex) {
    AssertTrueOrReturn(buttonIndex > 0);
    NSInteger actionSheetSectionIndex = buttonIndex - 1; // cancelButtonIndex equals 0
    self.selectedSection = self.actionSheetSections[actionSheetSectionIndex];
    [self.pickACategoryButton setTitle:self.selectedSection.displayName forState:UIControlStateNormal];
  }
}

#pragma mark - Lazy initalization

- (FDTakeController *)mediaController
{
  if (!_mediaController) {
    _mediaController = [MediaPickerHelper fdTakeControllerWithDelegate:self viewControllerForPresentingImagePickerController:self.imagePickerPresentingViewController];
  }
  return _mediaController;
}

#pragma mark - Size calculations 

- (CGFloat)headerViewHeightForWidth:(CGFloat)width
{
  return width * originalViewSize.height / originalViewSize.width;
}

@end
