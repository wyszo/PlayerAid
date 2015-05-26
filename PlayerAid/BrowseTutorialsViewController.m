//
//  PlayerAid
//

#import "BrowseTutorialsViewController.h"
#import "Section.h"
#import "SectionCell.h"
#import "CommonViews.h"


static NSString *const kSectionCellIdentifier = @"SectionCell";
static const CGFloat kRowHeight = 150.0f;


@interface BrowseTutorialsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) TWArrayTableViewDataSource *dataSource;
@property (strong, nonatomic) TWSimpleTableViewDelegate *delegate;
@end


@implementation BrowseTutorialsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setupLazyInitialization];
  [self setupDataSource];
  [self setupDelegate];
  [self setupTableView];
}

- (void)setupTableView
{
  self.sectionsTableView.rowHeight = kRowHeight;
  self.sectionsTableView.tableHeaderView = [CommonViews smallTableHeaderOrFooterView];
  self.sectionsTableView.tableFooterView = [CommonViews smallTableHeaderOrFooterView];
}

- (void)setupLazyInitialization
{
  self.sections = [NSArray tw_lazyWithBlock:^id{
    return [Section MR_findAll];
  }];
}

- (void)setupDataSource
{
  NSArray *sectionNames = [self.sections valueForKey:@"name"];
  AssertTrueOrReturn(sectionNames.count);
  
  NSArray *sectionDescriptions = [self.sections valueForKey:@"sectionDescription"];
  AssertTrueOrReturn(sectionDescriptions.count);
  
  self.dataSource = [[TWArrayTableViewDataSource alloc] initWithArray:sectionNames attachToTableView:self.sectionsTableView cellDequeueIdentifier:kSectionCellIdentifier];
  self.dataSource.configureCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[SectionCell class]]);
    SectionCell *sectionCell = (SectionCell *)cell;
    
    AssertTrueOrReturn(sectionNames.count > indexPath.row);
    sectionCell.titleLabel.text = sectionNames[indexPath.row];
    
    AssertTrueOrReturn(sectionDescriptions.count > indexPath.row);
    sectionCell.descriptionLabel.text = sectionDescriptions[indexPath.row];
  };
}

- (void)setupDelegate
{
  self.delegate = [[TWSimpleTableViewDelegate alloc] initAndAttachToTableView:self.sectionsTableView];
  self.delegate.deselectCellOnTouch = YES;
  
  self.delegate.cellSelectedBlock = ^(NSIndexPath *indexPath) {
    // TODO: push tutorials tableView with selected section filter
  };
}

@end
