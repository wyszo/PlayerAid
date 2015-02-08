//
//  PlayerAid
//

#import "CreateTutorialHeaderViewController.h"
#import "AlertFactory.h"


@interface CreateTutorialHeaderViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
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
  // TODO: show categories list
}

- (IBAction)save:(id)sender
{
  if (!self.titleTextField.text.length) {
    [AlertFactory showCreateTutorialNoTitleAlertView];
  }
  
  // TODO: save a new tutorial
}

@end
