//
//  PlayerAid
//

#import "CreateTutorialHeaderViewController.h"
#import <NSManagedObject+MagicalFinders.h>
#import <KZAsserts.h>
#import "ApplicationViewHierarchyHelper.h"
#import "AlertFactory.h"
#import "Section.h"


@interface CreateTutorialHeaderViewController () <UITextFieldDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickACategoryButton;
@property (strong, nonatomic) NSArray *actionSheetSections;
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
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a category" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
  
  self.actionSheetSections = [Section MR_findAll];
  for (Section *section in self.actionSheetSections) {
    [actionSheet addButtonWithTitle:section.name];
  }
  
  [actionSheet showFromTabBar:[ApplicationViewHierarchyHelper applicationTabBarController].tabBar];
}

- (IBAction)save:(id)sender
{
  if (!self.titleTextField.text.length) {
    [AlertFactory showCreateTutorialNoTitleAlertView];
  }
  
  // TODO: save a new tutorial
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != actionSheet.cancelButtonIndex) {
    AssertTrueOrReturn(buttonIndex - 1 >= 0);
    Section *selectedSection = self.actionSheetSections[buttonIndex - 1];
    [self.pickACategoryButton setTitle:selectedSection.name forState:UIControlStateNormal];
  }
}

@end
