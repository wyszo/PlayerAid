//
//  PlayerAid
//

#import "SettingsViewController.h"
#import "NSArrayTableViewDataSource.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (strong, nonatomic) NSArrayTableViewDataSource *dataSource;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Settings";
  [self setupTableView];
}

- (void)setupTableView
{
  NSArray *settings = @[
                        @"Rate this app",
                        @"Terms of Service",
                        @"Privacy Policy",
                        @"Log out"
                        ];
  self.dataSource = [[NSArrayTableViewDataSource alloc] initWithArray:settings attachToTableView:self.settingsTableView cellDequeueIdentifier:@"SettingsCell"];
  
  self.dataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn(indexPath.row < settings.count);
    cell.textLabel.text = settings[indexPath.row];
  };
}

@end
