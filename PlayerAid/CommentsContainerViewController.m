//
//  PlayerAid
//

@import KZAsserts;
@import CoreData;
@import MagicalRecord;
@import TWCommonLib;
@import BlocksKit;
#import "CommentsContainerViewController.h"
#import "TutorialCommentsController.h"
#import "TutorialCommentCell.h"
#import "TutorialComment.h"
#import "Tutorial.h"
#import "CommonViews.h"
#import "CommentsTableViewDataSource.h"
#import "AlertFactory.h"
#import "UsersFetchController.h"
#import "AuthenticatedServerCommunicationController.h"

static NSString *const kNibFileName = @"CommentsContainerView";

static NSString * const kTutorialCommentNibName = @"TutorialCommentCell";
static NSString * const kTutorialCommentCellIdentifier = @"TutorialCommentCell";

@interface CommentsContainerViewController ()
@property (nonatomic, weak) IBOutlet UITableView *commentsTableView;
@property (nonatomic, strong) TWCoreDataTableViewDataSource *dataSource;
@property (nonatomic, weak) TutorialCommentsController *commentsController;
@property (nonatomic, weak) IBOutlet UIView *noCommentsOverlayView;
@property (nonatomic, strong) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, strong) TWTableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@property (nonatomic, copy) EditCommentBlock editCommentActionSheetOptionSelectedBlock;
@end

@implementation CommentsContainerViewController

#pragma mark - Setup

- (void)viewDidLoad
{
  [super viewDidLoad];
  AssertTrueOr(self.tutorial && @"Tutorial property is mandatory",);
  AssertTrueOr(self.editCommentActionSheetOptionSelectedBlock && @"setting edit comment action is mandatory",);

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
    TutorialCommentCell *cell = [weakSelf.commentsTableView cellForRowAtIndexPath:indexPath];
    AssertTrueOrReturn(cell);
    
    if (![self shouldShowCommentActionSheetOnCellSelection]) {
      CallBlock(weakSelf.resignMakeOrEditCommentFirstResponderBlock);
      return;
    }
    
    if ([cell isExpanded]) {
      AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
      [weakSelf showUserActionsActionSheetForComment:(TutorialComment *)object withTableViewCell:cell];
    }
    else {
      [cell expandCell];
    }
  };
  [self.commentsTableView bk_associateValue:delegate withKey:@"tableViewDelegate"];
}

- (BOOL)shouldShowCommentActionSheetOnCellSelection
{
  if (self.isAnyCommentBeingEditedOrAddedBlock) {
    return !(self.isAnyCommentBeingEditedOrAddedBlock());
  }
  return YES;
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

- (void)setTutorialCommentsController:(TutorialCommentsController *)commentsController
{
  AssertTrueOrReturn(commentsController);
  _commentsController = commentsController;
}

- (void)setTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(!self.tutorial && @"You shouldn't try to reinitialize self.tutorial");
  _tutorial = tutorial;
}

- (void)setEditCommentActionSheetOptionSelectedBlock:(EditCommentBlock)block
{
  AssertTrueOrReturn(block);
  AssertTrueOrReturn(!self.editCommentActionSheetOptionSelectedBlock && @"You shouldn't try to reinitialize edit comment action");
  _editCommentActionSheetOptionSelectedBlock = block;
}

#pragma mark - Comment cells

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
  commentCell.likeButtonPressedBlock = ^(TutorialComment *comment) {
    [AuthenticatedServerCommunicationController.sharedInstance.serverCommunicationController likeComment:comment];
  };
  
  if (!object) {
    object = [self.dataSource objectAtIndexPath:indexPath];
  }
  AssertTrueOrReturn([object isKindOfClass:[TutorialComment class]]);
  TutorialComment *comment = (TutorialComment *)object;
  
  [commentCell configureWithTutorialComment:comment];
  [self updateCellSelectionHightlight:commentCell forComment:comment];
}

- (void)updateCellSelectionHightlight:(nonnull TutorialCommentCell *)cell forComment:(nonnull TutorialComment *)comment
{
  AssertTrueOrReturn(cell);
  AssertTrueOrReturn(comment);
  
  BOOL isCommentBeingEdited = NO;
  if (self.isCommentBeingEditedBlock) {
    isCommentBeingEdited = self.isCommentBeingEditedBlock(comment);
  }
  [cell setHighlighted:isCommentBeingEdited];
}

- (void)showUserActionsActionSheetForComment:(nonnull TutorialComment *)comment withTableViewCell:(nonnull UITableViewCell *)cell
{
  AssertTrueOrReturn(comment);
  AssertTrueOrReturn(cell);
  AssertTrueOrReturn(self.commentsController && @"comments controller has to be set for reporting comments!");
  
  UIViewController *actionSheetPresenter = [UIWindow tw_keyWindow].rootViewController;
  AssertTrueOrReturn(actionSheetPresenter);
  AssertTrueOr([actionSheetPresenter isKindOfClass:[UITabBarController class]],);
  
  UIAlertController *actionSheet = [self.commentsController reportCommentAlertController:comment];
  
  if ([self isOwnComment:comment]) {
    AssertTrueOrReturn(self.editCommentActionSheetOptionSelectedBlock);
    actionSheet = [self.commentsController editOrDeleteCommentActionSheet:comment withTableViewCell:cell editCommentAction:self.editCommentActionSheetOptionSelectedBlock];
  }
  
  /**
   Technical debt: can't figure out why despite running on a main thread, the action sheet appears with a delay (on iOS9)! Dispatch async as a workaround..
  */
  AssertTrueOr([NSThread isMainThread],);
  DISPATCH_ASYNC_ON_MAIN_THREAD(^{
    [actionSheetPresenter presentViewController:actionSheet animated:YES completion:nil];
  });
}

#pragma mark - Private

- (BOOL)isOwnComment:(nonnull TutorialComment *)comment
{
  AssertTrueOrReturnNo(comment);
  User *currentUser = [UsersFetchController.sharedInstance currentUserInContext:comment.managedObjectContext];
  return (comment.madeBy == currentUser); // objects from same managedObjectContext, pointer equality check is enough
}

@end
