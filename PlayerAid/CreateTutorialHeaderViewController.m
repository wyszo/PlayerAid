//
//  PlayerAid
//

#import "CreateTutorialHeaderViewController.h"


@interface CreateTutorialHeaderViewController () <UITextFieldDelegate>
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

@end
