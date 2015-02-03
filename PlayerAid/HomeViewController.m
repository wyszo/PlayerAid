//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <KZAsserts.h>
#import "HomeViewController.h"
#import "TutorialsTableDataSource.h"
#import "TutorialDetailsViewController.h"


static NSString *const kShowTutorialDetailsSegueName = @"ShowTutorialDetails";


@interface HomeViewController () <TutorialsTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *latestFilterView;
@property (weak, nonatomic) IBOutlet UIView *followingFilterView;

@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tutorialsTableView;

@property (weak, nonatomic) Tutorial *lastSelectedTutorial;

@end


@implementation HomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Home";
  
  // TODO: it's not clear that data source attaches itself to a tableView passed as a parameter, rethink this
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initWithTableView:self.tutorialsTableView];
  
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"draft = NO or draft = nil"];
  self.tutorialsTableDataSource.tutorialTableViewDelegate = self;
}

#pragma mark - latest & following buttons bar

- (IBAction)latestFilterSelected:(id)sender
{
  // TODO: change predicate to show latest tutorials
}

- (IBAction)followingFilterSelected:(id)sender
{
  // TODO: change predicate to show tutorials of the users I follow
}

#pragma mark - TutorialTableViewDelegate

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  self.lastSelectedTutorial = tutorial;
  [self performSegueWithIdentifier:kShowTutorialDetailsSegueName sender:self];
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
