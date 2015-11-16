//
//  PlayerAid
//

@import KZAsserts;
@import CoreData;
@import MagicalRecord;
@import TWCommonLib;
#import "CommentsContainerViewController.h"
#import "TutorialCommentCell.h"
#import "TutorialComment.h"
#import "Tutorial.h"

static NSString *const kNibFileName = @"CommentsContainerView";

static NSString * const kTutorialCommentNibName = @"TutorialCommentCell";
static NSString * const kTutorialCommentCellIdentifier = @"TutorialCommentCell";

@interface CommentsContainerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) TWCoreDataTableViewDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UIView *noCommentsOverlayView;
@property (strong, nonatomic) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (strong, nonatomic) Tutorial *tutorial;
@end

@implementation CommentsContainerViewController

#pragma mark - Setup

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"Tutorial property is mandatory",);
  
  [self setupCommentsTableView];
}

- (void)setupCommentsTableView
{
  [self setupCommentsTableViewCells];
  [self setupCommentsTableViewDataSource];
  [self setupCommentsTableViewOverlayBehaviour];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
  // TODO: update tableViewOverlayBehaviour on CoreData update!
}

- (void)setupCommentsTableViewCells
{
  [self.commentsTableView registerNibWithName:kTutorialCommentNibName forCellReuseIdentifier:kTutorialCommentCellIdentifier];
}

- (void)setupCommentsTableViewDataSource
{
  self.dataSource = [[TWCoreDataTableViewDataSource alloc] initWithCellReuseIdentifier:@"TutorialCommentCell" configureCellWithObjectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[TutorialCommentCell class]]);
    TutorialCommentCell *commentCell = (TutorialCommentCell *)cell;
    
    AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
    TutorialComment *comment = (TutorialComment *)object;
    [commentCell configureWithTutorialComment:comment];
  }];
  defineWeakSelf();
  self.dataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    defineStrongSelf();
    NSFetchRequest *fetchRequest = [TutorialComment MR_requestAllSortedBy:@"createdOn" ascending:YES];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"belongsToTutorial == %@", strongSelf.tutorial];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSFetchedResultsController *fetchedResultsController = [TutorialComment MR_fetchController:fetchRequest delegate:nil useFileCache:NO groupedBy:nil inContext:context];
    [fetchedResultsController tw_performFetchAssertResults];
    // TODO: introduce FetchResultsControllerBinder so that the comments UI is refreshed when new data comes in
    
    return fetchedResultsController;
  };
  self.commentsTableView.dataSource = self.dataSource;
}

- (void)setupCommentsTableViewOverlayBehaviour
{
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.commentsTableView dataSource:self.dataSource overlayView:self.noCommentsOverlayView allowScrollingWhenNoCells:NO];
}

#pragma mark - Setters

- (void)setTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(!self.tutorial && @"Can't reinitialize self.tutorial");
  _tutorial = tutorial;
}

@end
