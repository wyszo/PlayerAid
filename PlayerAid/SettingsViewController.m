//
//  PlayerAid
//

#import "SettingsViewController.h"
#import "TWArrayTableViewDataSource.h"
#import "TWSimpleTableViewDelegate.h"
#import "JourneyController.h"
#import "AlertFactory.h"


static NSString *const kSettingsCellReuseIdentifier = @"SettingsCell";
static NSString *const kSettingsLogoutItem = @"Log out";


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (strong, nonatomic, readonly) NSArray *settings;
@property (strong, nonatomic) TWArrayTableViewDataSource *dataSource;
@property (strong, nonatomic) TWSimpleTableViewDelegate *delegate;

@end


@implementation SettingsViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupLazyInitializers];
  
  self.title = @"Settings";
  [self setupTableViewDataSource];
  [self setupTableViewDelegate];
}

- (void)setupLazyInitializers
{
  _settings = [NSArray tw_lazyWithBlock:^{
    return @[
             @"Rate this app",
             @"Terms of Service",
             @"Privacy Policy",
             kSettingsLogoutItem
           ];
  }];
}

- (void)setupTableViewDataSource
{
  self.dataSource = [[TWArrayTableViewDataSource alloc] initWithArray:self.settings attachToTableView:self.settingsTableView cellDequeueIdentifier:kSettingsCellReuseIdentifier];
  
  defineWeakSelf();
  self.dataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn(indexPath.row < weakSelf.settings.count);
    cell.textLabel.text = weakSelf.settings[indexPath.row];
  };
}

- (void)setupTableViewDelegate
{
  self.delegate = [[TWSimpleTableViewDelegate alloc] initAndAttachToTableView:self.settingsTableView];
  self.delegate.deselectCellOnTouch = YES;
  
  defineWeakSelf();
  self.delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    if ([weakSelf isIndexPath:indexPath forObject:kSettingsLogoutItem]) {
      
      [AlertFactory showLogoutConfirmationAlertViewWithOKAction:^{
        [[JourneyController new] clearAppDataAndPerformLoginSegueAnimated:YES];
      }];
    }
  };
}

#pragma mark - Auxiliary methods

- (BOOL)isIndexPath:(NSIndexPath *)indexPath forObject:(NSString *)object
{
  AssertTrueOrReturnNo(indexPath);
  AssertTrueOrReturnNo(object);
  return (indexPath.row == [self.settings indexOfObject:object]);
}

@end
