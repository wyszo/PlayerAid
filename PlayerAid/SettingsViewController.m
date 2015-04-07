//
//  PlayerAid
//

#import "SettingsViewController.h"
#import "NSArrayTableViewDataSource.h"
#import "NSSimpleTableViewDelegate.h"


static NSString *const kSettingsCellReuseIdentifier = @"SettingsCell";
static NSString *const kSettingsLogoutItem = @"Log out";


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (weak, nonatomic, readonly) NSArray *settings;
@property (strong, nonatomic) NSArrayTableViewDataSource *dataSource;
@property (strong, nonatomic) NSSimpleTableViewDelegate *delegate;

@end


@implementation SettingsViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Settings";
  [self setupTableViewDataSource];
  [self setupTableViewDelegate];
}

- (void)setupTableViewDataSource
{
  self.dataSource = [[NSArrayTableViewDataSource alloc] initWithArray:self.settings attachToTableView:self.settingsTableView cellDequeueIdentifier:kSettingsCellReuseIdentifier];
  
  defineWeakSelf();
  self.dataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn(indexPath.row < weakSelf.settings.count);
    cell.textLabel.text = weakSelf.settings[indexPath.row];
  };
}

- (void)setupTableViewDelegate
{
  self.delegate = [[NSSimpleTableViewDelegate alloc] initAndAttachToTableView:self.settingsTableView];
  self.delegate.deselectCellOnTouch = YES;
  
  defineWeakSelf();
  self.delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    if ([weakSelf isIndexPath:indexPath forObject:kSettingsLogoutItem]) {
      // TODO: implement facebook logout logic
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

#pragma mark - Lazy initialization

- (NSArray *)settings
{
  static NSArray *settings;
  if (!settings) {
    settings = @[
                  @"Rate this app",
                  @"Terms of Service",
                  @"Privacy Policy",
                  kSettingsLogoutItem
                ];
  }
  return settings;
}

@end
