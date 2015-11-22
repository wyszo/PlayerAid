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
#import "AlertControllerFactory.h"
#import "AlertFactory.h"
#import "AuthenticatedServerCommunicationController.h"

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
  [self setupCommentsTableViewDelegate];
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

- (void)setupCommentsTableViewDelegate
{
  TWSimpleTableViewDelegate *delegate = [[TWSimpleTableViewDelegate alloc] initAndAttachToTableView:self.commentsTableView];
  defineWeakSelf();
  delegate.cellSelectedExtendedBlock = ^(NSIndexPath *indexPath, id object) {
    AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
    
    UIAlertController *actionSheet = [AlertControllerFactory reportCommentActionControllerWithAction:^() {
      [AlertFactory showReportCommentAlertViewWithOKAction:^{
        TutorialComment *comment = (TutorialComment *)object;
        [[AuthenticatedServerCommunicationController sharedInstance] reportCommentAsInappropriate:comment completion:^(NSHTTPURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
            [AlertFactory showGenericErrorAlertViewNoRetry];
          }
          else {
            // TODO: comment text should locally change to 'Comment was removed as inappropriate'
            
            // This needs to persist after fetching new comments! Need to introduce local array of comment ids reported as inappropriate by an user (not recommened). Or even better: handle this server-side, so server always returns the comment as flagged as inappropriate to a current user.
            // So ideally server should return a comment object in here with text changed to 'inappropriate'
          }
        }];
      }];
    }];
    [weakSelf presentViewController:actionSheet animated:YES completion:nil];
  };
  [self.commentsTableView bk_associateValue:delegate withKey:@"tableViewDelegate"];
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
  
  defineWeakSelf();
  commentCell.willChangeCellHeightBlock = ^() {
    [weakSelf.commentsTableView beginUpdates];
  };
  commentCell.didChangeCellHeightBlock = ^() {
    [weakSelf.commentsTableView endUpdates];
  };
  
  if (!object) {
    object = [self.dataSource objectAtIndexPath:indexPath];
  }
  AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
  TutorialComment *comment = (TutorialComment *)object;
  
  [commentCell configureWithTutorialComment:comment];
}

@end
