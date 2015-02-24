//
//  PlayerAid
//

#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"


@interface ProfileViewController ()

@property (strong, nonatomic) PlayerInfoView *playerInfoView;
@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;

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
  
  self.tutorialsTableDataSource.swipeToDeleteEnabled = YES;
  
  [self setupTableHeaderView];
  self.playerInfoView.user = activeUser;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

#pragma mark - Header View initialization

- (void)setupTableHeaderView
{
  const NSUInteger kPlayerInforViewHeight = 310;
  const NSUInteger kTutorialsFilterView = 54;
  const NSUInteger kDistanceToFirstTutorial = 18;
  
  NSUInteger windowWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
  
  self.playerInfoView = [[PlayerInfoView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, kPlayerInforViewHeight)];
  
  CGRect containerFrame = CGRectMake(0, 0, windowWidth, kPlayerInforViewHeight + kTutorialsFilterView + kDistanceToFirstTutorial);
  UIView *containerView = [self wrapView:self.playerInfoView inAContainerViewWithFrame:containerFrame];
  
  self.tutorialTableView.tableHeaderView = containerView;
}

- (UIView *)wrapView:(UIView *)view inAContainerViewWithFrame:(CGRect)frame
{
  UIView *containerView = [[UIView alloc] initWithFrame:frame];
  containerView.backgroundColor = [UIColor whiteColor];
  [containerView addSubview:view];
  return containerView;
}

@end
