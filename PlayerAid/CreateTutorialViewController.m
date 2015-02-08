//
//  PlayerAid
//

#import "CreateTutorialViewController.h"
#import "NavigationBarCustomizationHelper.h"
#import "CreateTutorialHeaderView.h"

@interface CreateTutorialViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@end


@implementation CreateTutorialViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupNavigationBarButtons];
  
  NSUInteger windowWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
  self.tutorialTableView.tableHeaderView = [[CreateTutorialHeaderView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 200)];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - NavigationBar buttons

- (void)setupNavigationBarButtons
{
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
