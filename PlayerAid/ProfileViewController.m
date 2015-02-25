//
//  PlayerAid
//

#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"
#import "ColorsHelper.h"


static const NSUInteger kSegmentedControlHeight = 54.0f;
static const NSUInteger kPlayerInfoViewHeight = 310;
static const NSUInteger kDistanceBetweenPlayerInfoAndFirstTutorial = 18;


@interface ProfileViewController () <TutorialsTableViewDelegate>

@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;

@end


@implementation ProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  User *activeUser = [User MR_findFirst]; // TODO: hook up correct user in here!
  
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.tutorialTableView];
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"createdBy = %@ AND state != %@", activeUser, kTutorialStateUnsaved];
  self.tutorialsTableDataSource.groupBy = @"state";
  self.tutorialsTableDataSource.showSectionHeaders = YES;
  self.tutorialsTableDataSource.tutorialTableViewDelegate = self;
  
  self.tutorialsTableDataSource.swipeToDeleteEnabled = YES;
  
  [self setupTableHeaderView];
  self.playerInfoView.user = activeUser;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateTableViewNoTutorialsOverlay];
}

- (void)updateTableViewNoTutorialsOverlay
{
  if ([self.tutorialsTableDataSource totalNumberOfCells] == 0) {
    self.tutorialTableView.scrollEnabled = NO;
    self.noTutorialsLabel.hidden = NO;
    self.noTutorialsLabel.text = @"You haven't created any tutorials yet!";
  }
  else {
    self.tutorialTableView.scrollEnabled = YES;
    self.noTutorialsLabel.hidden = YES;
  }
}

#pragma mark - Header View initialization

- (void)setupTableHeaderView
{
  NSUInteger windowWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
  
  self.playerInfoView = [[PlayerInfoView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, kPlayerInfoViewHeight)];
  
  CGRect containerFrame = CGRectMake(0, 0, windowWidth, kPlayerInfoViewHeight + kSegmentedControlHeight + kDistanceBetweenPlayerInfoAndFirstTutorial);
  UIView *containerView = [self wrapView:self.playerInfoView inAContainerViewWithFrame:containerFrame];
  
  UIView *segmentedControl = [self flatSegmentedControlWithYOffset:kPlayerInfoViewHeight width:windowWidth];
  [containerView addSubview:segmentedControl];
  
  self.tutorialTableView.tableHeaderView = containerView;
}

- (UIView *)flatSegmentedControlWithYOffset:(CGFloat)yOffset width:(CGFloat)width
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, width, kSegmentedControlHeight)];
  view.backgroundColor = [ColorsHelper tutorialsUnselectedFilterButtonColor];
  return view;
}

- (UIView *)wrapView:(UIView *)view inAContainerViewWithFrame:(CGRect)frame
{
  UIView *containerView = [[UIView alloc] initWithFrame:frame];
  containerView.backgroundColor = [UIColor whiteColor];
  [containerView addSubview:view];
  return containerView;
}

#pragma mark - Tutorials Table View Delegate

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  // no action, required method
}

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows
{
  [self updateTableViewNoTutorialsOverlay];
}

@end
