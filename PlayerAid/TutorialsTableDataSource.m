//
//  PlayerAid
//

#import "TutorialsTableDataSource.h"
#import "Tutorial.h"
#import "TutorialTableViewCell.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialCellHelper.h"
#import "TWCoreDataTableViewDataSource.h"
#import "TWTableViewFetchedResultsControllerBinder.h"
#import "TutorialSectionHeaderView.h"
#import "AlertFactory.h"
#import "UITableView+TableViewHelper.h"
#import "ProfileViewController.h"
#import "UsersFetchController.h"


static NSString *const kTutorialCellReuseIdentifier = @"TutorialCell";


@interface TutorialsTableDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) TWCoreDataTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) TWTableViewFetchedResultsControllerBinder *fetchedResultsControllerBinder;
@end


@implementation TutorialsTableDataSource

#pragma mark - Initilization

- (instancetype)initAttachingToTableView:(UITableView *)tableView
{
  AssertTrueOrReturnNil(tableView);
  // AssertTrueOrReturnNil(tableView.delegate && @"tableView already has a delegate - overriding it probably not desired"); // TODO: we want this, but it'll break existing implementation
  
  self = [super init];
  if (self) {
    _tableView = tableView;
    
    _tableView.delegate = self;
    [_tableView registerNib:[TutorialCellHelper nibForTutorialCell] forCellReuseIdentifier:kTutorialCellReuseIdentifier];
    
    [self initFetchedResultsControllerBinder];
    [self initTableViewDataSource];
  }
  return self;
}

- (void)initFetchedResultsControllerBinder
{
  __weak typeof(self) weakSelf = self;
  self.fetchedResultsControllerBinder = [[TWTableViewFetchedResultsControllerBinder alloc] initWithTableView:self.tableView configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  }];
  self.fetchedResultsControllerBinder.numberOfObjectsChangedBlock = ^(NSInteger objectCount){
    if ([(NSObject *)(weakSelf.tutorialTableViewDelegate) respondsToSelector:@selector(numberOfRowsDidChange:)]) {
      [weakSelf.tutorialTableViewDelegate numberOfRowsDidChange:objectCount];
    }
  };
}

- (void)initTableViewDataSource
{
  __weak typeof(self) weakSelf = self;
  
  self.tableViewDataSource = [[TWCoreDataTableViewDataSource alloc] initWithCellreuseIdentifier:kTutorialCellReuseIdentifier configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    [weakSelf configureCell:cell atIndexPath:indexPath];
  }];
  self.tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
    AssertTrueOr(weakSelf.fetchedResultsControllerBinder, );
    return [Tutorial MR_fetchAllSortedBy:@"state,createdAt" ascending:YES withPredicate:weakSelf.predicate groupBy:weakSelf.groupBy delegate:weakSelf.fetchedResultsControllerBinder];
  };
  self.tableView.dataSource = _tableViewDataSource;
}

#pragma mark - Handling CoreData fetching

- (void)setPredicate:(NSPredicate *)predicate
{
  if (predicate != _predicate) {
    _predicate = predicate;
    
    [self.tableViewDataSource resetFetchedResultsController];
    [self.tableView reloadData];
  }
}

- (void)setGroupBy:(NSString *)groupBy
{
  if (groupBy != _groupBy) {
    _groupBy = groupBy;
    
    [self.tableViewDataSource resetFetchedResultsController];
    [self.tableView reloadData];
  }
}

#pragma mark - Cell configuration

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn(cell);
  AssertTrueOrReturn([cell isKindOfClass:[TutorialTableViewCell class]]);
  TutorialTableViewCell *tutorialCell = (TutorialTableViewCell *)cell;
  Tutorial *tutorial = [self.tableViewDataSource objectAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [tutorialCell configureWithTutorial:tutorial];
 
  BOOL isLastCellInTableView = [indexPath isEqual:[self.tableViewDataSource lastTableViewCellIndexPath]];
  tutorialCell.showBottomGap = !isLastCellInTableView;
  tutorialCell.canBeDeletedOnSwipe = self.swipeToDeleteEnabled;

  if (self.userAvatarSelectedBlock) {
    tutorialCell.userAvatarSelectedBlock = self.userAvatarSelectedBlock;
  }
  
  tutorialCell.tutorialFavouritedBlock = ^(BOOL favourited, TutorialTableViewCell *tutorialCell) {
    VoidBlock showGenericErrorBlock = ^() {
      DISPATCH_ASYNC_ON_MAIN_THREAD(^{
        [AlertFactory showGenericErrorAlertView];
      });
    };
    
    if (favourited) {
      [[AuthenticatedServerCommunicationController sharedInstance] likeTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
          showGenericErrorBlock();
        }
        else {
          // TODO: extract this from here!
          [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            Tutorial *tutorialInContext = [tutorial MR_inContext:localContext];
            User *user = [[UsersFetchController sharedInstance] currentUserInContext:localContext];
            
            [user addLikesObject:tutorialInContext];
            [tutorialInContext addLikedByObject:user];
          }];
          [tutorialCell updateLikeButtonState];
        }
      }];
    }
    else {
      [[AuthenticatedServerCommunicationController sharedInstance] unlikeTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (error) {
          showGenericErrorBlock();
        }
        else {
         
          // TODO: extract this from here!
          [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            Tutorial *tutorialInContext = [tutorial MR_inContext:localContext];
            User *user = [[UsersFetchController sharedInstance] currentUserInContext:localContext];
            
            [user removeLikesObject:tutorialInContext];
            [tutorialInContext removeLikedByObject:user];
          }];
          [tutorialCell updateLikeButtonState];
        }
      }];
    }
  };
}

#pragma mark - DataSource - deleting cells

- (BOOL)swipeToDeleteEnabled
{
  return (self.tableViewDataSource.deleteCellOnSwipeBlock != nil);
}

- (void)setSwipeToDeleteEnabled:(BOOL)swipeToDeleteEnabled
{
  __weak typeof(self) weakSelf = self;
  _tableViewDataSource.deleteCellOnSwipeBlock = ^(NSIndexPath *indexPath) {
    [weakSelf deleteTutorialAtIndexPath:indexPath];
  };
}

- (void)deleteTutorialAtIndexPath:(NSIndexPath *)indexPath
{
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  if (tutorial.draftValue) {
    [self showDeleteDraftTutorialAlertViewForTutorialAtIndexPath:indexPath];
    return;
  }
  
  // in review or published tutorial - ask for confirmation
  __weak typeof(self) weakSelf = self;
  [AlertFactory showDeleteTutorialAlertConfirmationWithOkAction:^{
    [weakSelf makeDeleteTutorialNetworkRequestForTutorial:tutorial];
  } cancelAction:^{
    [weakSelf.tableView reloadRowAtIndexPath:indexPath];
  }];
}

- (void)makeDeleteTutorialNetworkRequestForTutorial:(Tutorial *)tutorial
{
  // Make a delete tutorial network request for in review/published tutorials
  [AuthenticatedServerCommunicationController.sharedInstance deleteTutorial:tutorial completion:^(NSError *error) {
    if (error) {
      // TODO: queue and retry delete tutorial reqeust!
      [AlertFactory showOKAlertViewWithMessage:@"<Delete tutorial request failed, retrying not implemented yet!>"];
    }
    else {
      // Remove tutorial object from CoreData, tableView will automatically pick up the change
      [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Tutorial *tutorialInLocalContext = [tutorial MR_inContext:localContext];
        [tutorialInLocalContext MR_deleteInContext:localContext];
      }];
      
      [AlertFactory showOKAlertViewWithMessage:@"<Tutorial removed from server!>"];
    }
  }];
}

- (void)showDeleteDraftTutorialAlertViewForTutorialAtIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn(indexPath);
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  
  __weak typeof(self) weakSelf = self;
  [AlertFactory showDeleteTutorialAlertConfirmationWithOkAction:^{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      [[tutorial MR_inContext:localContext] MR_deleteEntity];
    }];
  } cancelAction:^{
    [weakSelf.tableView reloadRowAtIndexPath:indexPath];
  }];
}

#pragma mark - Auxiliary methods

- (Tutorial *)tutorialAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.tableViewDataSource objectAtIndexPath:indexPath];
}

- (NSInteger)objectCount
{
  AssertTrueOr(self.tableViewDataSource, return 0;);
  return self.tableViewDataSource.objectCount;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  
  if ([self.tutorialTableViewDelegate respondsToSelector:@selector(didSelectRowWithTutorial:)]) {
    [self.tutorialTableViewDelegate didSelectRowWithTutorial:tutorial];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  BOOL withBottomGap = ![indexPath isEqual:[self.tableViewDataSource lastTableViewCellIndexPath]];
  return [TutorialTableViewCell cellHeightForCellWithBottomGap:withBottomGap];
}

#pragma mark - TableView Delegate: Section headers

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  if (self.showSectionHeaders) {
    return [self sectionHeaderViewForSection:section];
  }
  else {
    return nil;
  }
}

- (TutorialSectionHeaderView *)sectionHeaderViewForSection:(NSInteger)section
{
  TutorialSectionHeaderView *sectionHeaderView = [[TutorialSectionHeaderView alloc] init];
  
  id<NSFetchedResultsSectionInfo> sectionInfo = [self.tableViewDataSource sectionInfoForSection:section];
  NSString *sectionName = sectionInfo.name;
  AssertTrueOr(sectionName.length, ;);
  
  sectionHeaderView.titleLabel.text = sectionName;
  return sectionHeaderView;
}

- (NSInteger)numberOfRowsForSectionNamed:(NSString *)sectionName
{
  AssertTrueOr(sectionName.length, return 0;);
  
  NSInteger sectionsCount = self.tableViewDataSource.sectionsCount;
  for (int sectionIndex=0; sectionIndex < sectionsCount; sectionIndex++) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.tableViewDataSource sectionInfoForSection:sectionIndex];
    if ([sectionInfo.name.lowercaseString isEqual:sectionName.lowercaseString]) {
      return sectionInfo.numberOfObjects;
    }
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if (self.showSectionHeaders) {
    const CGFloat kSectionHeaderHeight = 32.0f;
    return kSectionHeaderHeight;
  }
  return 0.0;
}

@end
