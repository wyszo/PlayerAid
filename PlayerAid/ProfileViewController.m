//
//  PlayerAid
//

#import <NSManagedObject+MagicalFinders.h>
#import "ProfileViewController.h"
#import "PlayerInfoView.h"
#import "TutorialsTableDataSource.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet PlayerInfoView *playerInfoView;

@property (weak, nonatomic) IBOutlet UITableView *tutorialTableView;
@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  User *activeUser = [User MR_findFirst]; // TODO: hook up correct user in here!
  self.playerInfoView.user = activeUser;
  
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.tutorialTableView];
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"createdBy = %@", activeUser];
}

@end
