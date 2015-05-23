//
//  PlayerAid
//

#import "HomeViewController.h"
#import "TutorialsTableDataSource.h"
#import "TutorialDetailsViewController.h"
#import "ColorsHelper.h"
#import "ShowOverlayViewWhenTutorialsTableEmptyBehaviour.h"
#import "ProfileViewController.h"
#import "ApplicationViewHierarchyHelper.h"


static NSString *const kShowTutorialDetailsSegueName = @"ShowTutorialDetails";


@interface HomeViewController () <TutorialsTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *latestFilterBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *followingFilterBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *latestFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *followingFilterButton;

@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tutorialsTableView;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;

@property (weak, nonatomic) Tutorial *lastSelectedTutorial;

@property (nonatomic, strong) ShowOverlayViewWhenTutorialsTableEmptyBehaviour *tableViewOverlayBehaviour;

@end


@implementation HomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Home";
  
  // TODO: it's not clear that data source attaches itself to a tableView passed as a parameter, rethink this
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.tutorialsTableView];
  
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"state == %@", kTutorialStatePublished];
  self.tutorialsTableDataSource.tutorialTableViewDelegate = self;
  self.tutorialsTableDataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewControllerBlock:self allowPushingLoggedInUser:NO];
  
  [self setupTableViewHeader];
  
  self.noTutorialsLabel.text = @"No tutorials to show yet";
  self.tableViewOverlayBehaviour = [[ShowOverlayViewWhenTutorialsTableEmptyBehaviour alloc] initWithTableView:self.tutorialsTableView tutorialsDataSource:self.tutorialsTableDataSource overlayView:self.noTutorialsLabel allowScrollingWhenNoCells:NO];

  // TODO: Technical debt - we definitely shouldn't delay UI skinning like that!
  [self selectFilterLatest]; // intentional
  defineWeakSelf();
  DISPATCH_AFTER(0.01, ^{
    [weakSelf selectFilterLatest];
  });
  
  // TODO: Filter buttons should be extracted to a separate class
}

- (void)setupTableViewHeader
{
  // table view header - a white stripe in this case
  const CGFloat kHeaderGapHeight = 18.0f;
  UIView *headerViewGap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kHeaderGapHeight)];
  self.tutorialsTableView.tableHeaderView = headerViewGap;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - latest & following buttons bar

- (IBAction)latestFilterSelected:(id)sender
{
  // TODO: change predicate to show latest tutorials
  
  [self selectFilterLatest];
}

- (void)selectFilterLatest
{
  [self setLatestFilterButtonTextColor:[ColorsHelper tutorialsSelectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsSelectedFilterButtonColor]];
  [self setFollowingFilterButtonTextColor:[ColorsHelper tutorialsUnselectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsUnselectedFilterButtonColor]];
}

- (IBAction)followingFilterSelected:(id)sender
{
  // TODO: change predicate to show tutorials of the users I follow
  
  [self selectFilterFollowing];
}

- (void)selectFilterFollowing
{
  [self setLatestFilterButtonTextColor:[ColorsHelper tutorialsUnselectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsUnselectedFilterButtonColor]];
  [self setFollowingFilterButtonTextColor:[ColorsHelper tutorialsSelectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsSelectedFilterButtonColor]];
}

- (void)setLatestFilterButtonTextColor:(UIColor *)latestColor andFollowingFilterButtonTextColor:(UIColor *)followingColor
{
  self.latestFilterButton.titleLabel.textColor = latestColor;
  self.followingFilterButton.titleLabel.textColor = followingColor;
}

- (void)setLatestFilterButtonTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
  self.latestFilterButton.titleLabel.textColor = textColor;
  self.latestFilterBackgroundView.backgroundColor = backgroundColor;
}

- (void)setFollowingFilterButtonTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
  self.followingFilterButton.titleLabel.textColor = textColor;
  self.followingFilterBackgroundView.backgroundColor = backgroundColor;
}

#pragma mark - TutorialTableViewDelegate

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  self.lastSelectedTutorial = tutorial;
  [self performSegueWithIdentifier:kShowTutorialDetailsSegueName sender:self];
}

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows
{
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:kShowTutorialDetailsSegueName]) {
    UIViewController *destinationController = [segue destinationViewController];
    AssertTrueOrReturn([destinationController isKindOfClass:[TutorialDetailsViewController class]]);
    TutorialDetailsViewController *tutorialDetailsViewController = (TutorialDetailsViewController *)destinationController;
    tutorialDetailsViewController.tutorial = self.lastSelectedTutorial;
  }
}

@end
