//
//  PlayerAid
//

#import "CreateTutorialHeaderViewController.h"
#import "TabBarHelper.h"
#import "AlertFactory.h"
#import "Section.h"


@interface CreateTutorialHeaderViewController () <UITextFieldDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickACategoryButton;

@property (strong, nonatomic) NSArray *actionSheetSections;
@property (strong, nonatomic) Section *selectedSection;
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
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.allowsEditing = YES;
  imagePicker.delegate = self.imagePickerControllerDelegate;
  [self.imagePickerControllerDelegate presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)pickACategory:(id)sender
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a category" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
  
  self.actionSheetSections = [Section MR_findAll];
  for (Section *section in self.actionSheetSections) {
    [actionSheet addButtonWithTitle:section.name];
  }

  UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  [actionSheet showInView:window];
}

- (IBAction)save:(id)sender
{
  if (!self.titleTextField.text.length) {
    [AlertFactory showCreateTutorialNoTitleAlertView];
    return;
  }
  
  if (!self.selectedSection) {
    [AlertFactory showCreateTutorialNoSectionSelectedAlertView];
    return;
  }

  if (self.saveDelegate) {
    [self.saveDelegate saveTutorialTitled:self.titleTextField.text section:self.selectedSection];
  }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != actionSheet.cancelButtonIndex && buttonIndex != actionSheet.destructiveButtonIndex) {
    AssertTrueOrReturn(buttonIndex >= 0);
    self.selectedSection = self.actionSheetSections[buttonIndex];
    [self.pickACategoryButton setTitle:self.selectedSection.name forState:UIControlStateNormal];
  }
}

@end
