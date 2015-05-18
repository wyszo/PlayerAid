//
//  PlayerAid
//

#import "HomeViewController.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *latestFilterView;
@property (weak, nonatomic) IBOutlet UIView *followingFilterView;

@end


@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Home";
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

@end
