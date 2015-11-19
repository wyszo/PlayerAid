//
//  PlayerAid
//

@import KZAsserts;
@import CoreData;
@import MagicalRecord;
@import TWCommonLib;
@import BlocksKit;
#import "CommentsContainerViewController.h"
#import "TutorialCommentCell.h"
#import "TutorialComment.h"
#import "Tutorial.h"
#import "CommonViews.h"
#import "CommentsTableViewDataSource.h"

static NSString *const kNibFileName = @"CommentsContainerView";

static NSString * const kTutorialCommentNibName = @"TutorialCommentCell";
static NSString * const kTutorialCommentCellIdentifier = @"TutorialCommentCell";

@interface CommentsContainerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) TWCoreDataTableViewDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UIView *noCommentsOverlayView;
@property (strong, nonatomic) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (strong, nonatomic) Tutorial *tutorial;
@property (strong, nonatomic) TWTableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@end

@implementation CommentsContainerViewController

#pragma mark - Setup

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"Tutorial property is mandatory",);

  [self setupFetchedResultsControllerBinder];
  [self setupCommentsTableView];
}

- (void)setupCommentsTableView
{
  [self setupCommentsTableViewProperties];
  [self setupCommentsTableViewCells];
  [self setupCommentsTableViewDataSource];
  [self setupCommentsTableViewOverlayBehaviour];
  
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

- (void)setupCommentsTableViewProperties
{
  self.commentsTableView.estimatedRowHeight = 70.0f;
  self.commentsTableView.tableFooterView = [CommonViews smallTableHeaderOrFooterView];
}

- (void)setupCommentsTableViewCells
{
  [self.commentsTableView registerNibWithName:kTutorialCommentNibName forCellReuseIdentifier:kTutorialCommentCellIdentifier];
}

- (void)setupCommentsTableViewDataSource
{
  defineWeakSelf();
  CommentsTableViewDataSourceConfigurator *configurator = [[CommentsTableViewDataSourceConfigurator alloc] initWithTutorial:self.tutorial cellReuseIdentifier:kTutorialCommentCellIdentifier fetchedResultsControllerDelegate:self.fetchedResultsControllerBinder configureCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell withObject:object atIndexPath:indexPath];
  }];
  [self.commentsTableView bk_associateValue:configurator withKey:@"dataSourceConfigurator"]; // binding to ensure block callbacks are invoked (technical debt)
  
  self.dataSource = [configurator dataSource];
  self.commentsTableView.dataSource = self.dataSource;
}

- (void)setupCommentsTableViewOverlayBehaviour
{
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.commentsTableView dataSource:self.dataSource overlayView:self.noCommentsOverlayView allowScrollingWhenNoCells:NO];
}

- (void)setupFetchedResultsControllerBinder
{
  defineWeakSelf();
  self.fetchedResultsControllerBinder = [[TWTableViewFetchedResultsControllerBinder alloc] initWithTableView:self.commentsTableView configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell withObject:nil atIndexPath:indexPath];
  }];
  self.fetchedResultsControllerBinder.objectInsertedAtIndexPathBlock = ^(NSIndexPath *indexPath) {
    [weakSelf.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
  };
}

#pragma mark - Setters

- (void)setTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(!self.tutorial && @"Can't reinitialize self.tutorial");
  _tutorial = tutorial;
}

#pragma mark - Private

- (void)configureCell:(nonnull UITableViewCell *)cell withObject:(nullable id)object atIndexPath:(nonnull NSIndexPath *)indexPath
{
  AssertTrueOrReturn(cell);
  AssertTrueOrReturn(indexPath);
  
  AssertTrueOrReturn([cell isKindOfClass:[TutorialCommentCell class]]);
  TutorialCommentCell *commentCell = (TutorialCommentCell *)cell;
  
  if (!object) {
    object = [self.dataSource objectAtIndexPath:indexPath];
  }
  AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
  TutorialComment *comment = (TutorialComment *)object;
  
  [commentCell configureWithTutorialComment:comment];
}

@end
