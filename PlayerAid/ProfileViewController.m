//
//  PlayerAid
//

#import <NSManagedObject+MagicalFinders.h>
#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"

@interface ProfileViewController ()

@property (weak, nonatomic) PlayerInfoView *playerInfoView;

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
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"createdBy = %@", activeUser];
  self.tutorialsTableDataSource.groupBy = @"draft";
  
  self.tutorialsTableDataSource.swipeToDeleteEnabled = YES;
  
  [self setupTableHeaderView];
  self.playerInfoView.user = activeUser;
}

- (void)setupTableHeaderView
{
  const NSUInteger kPlayerInforViewHeight = 316;
  const NSUInteger kTutorialsFilterView = 80;
  NSUInteger windowWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;

  UIView *headerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, kPlayerInforViewHeight + kTutorialsFilterView)];
  headerContainerView.backgroundColor = [UIColor grayColor];
  
  PlayerInfoView *playerInfoView = [[PlayerInfoView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, kPlayerInforViewHeight)];
  [headerContainerView addSubview:playerInfoView];
  
  self.tutorialTableView.tableHeaderView = headerContainerView;
}

@end
