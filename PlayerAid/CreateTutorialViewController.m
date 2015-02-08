//
//  PlayerAid
//

#import "CreateTutorialViewController.h"
#import "NavigationBarCustomizationHelper.h"

@interface CreateTutorialViewController ()
@end


@implementation CreateTutorialViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addNavigationBarCancelButton];
  [self addNavigationBarEditButton];
  [self addNavigationBarPublishButton];
  
  self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)addNavigationBarCancelButton
{
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];
  self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)addNavigationBarPublishButton
{
  UIBarButtonItem *publishButton = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonPressed)];
  self.navigationItem.rightBarButtonItem = publishButton;
}

- (void)addNavigationBarEditButton
{
  CGRect buttonRect = CGRectMake(0, 0, 60, 30);
  UIView *buttonContainer = [NavigationBarCustomizationHelper titleViewhWithButtonWithFrame:buttonRect title:@"Edit" target:self action:@selector(editButtonPressed)];
  self.navigationItem.titleView = buttonContainer;
}


#pragma mark - Actions

- (void)editButtonPressed
{
  // TODO: edit tutorial steps
}

- (void)publishButtonPressed
{
  // TODO: publish tutorial
}

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
