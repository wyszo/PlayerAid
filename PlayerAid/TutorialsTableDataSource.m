//
//  PlayerAid
//

#import <CoreData/CoreData.h>
#import <NSManagedObject+MagicalFinders.h>
#import <MagicalRecord+Actions.h>
#import <NSManagedObject+MagicalRecord.h>
#import <KZAsserts.h>
#import "TutorialsTableDataSource.h"
#import "Tutorial.h"
#import "TutorialTableViewCell.h"
#import "ServerCommunicationController.h"


static NSString *const kTutorialCellReuseIdentifier = @"TutorialCell";
static NSString *const kTutorialCellNibName = @"TutorialTableViewCell";


@interface TutorialsTableDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) UITableView *tableView;
@end


@implementation TutorialsTableDataSource

#pragma mark - Initilization

- (instancetype)initWithTableView:(UITableView *)tableView
{
  self = [super init];
  if (self) {
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UINib *tableViewCellNib = [self nibForTutorialCell];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kTutorialCellReuseIdentifier];
  }
  return self;
}

#pragma mark - Handling CoreData fetching

- (void)setPredicate:(NSPredicate *)predicate
{
  if (predicate != _predicate) {
    _predicate = predicate;
    
    _fetchedResultsController = nil;
    [self.tableView reloadData];
  }
}

- (NSFetchedResultsController *)fetchedResultsController
{
  if (!_fetchedResultsController) {
    _fetchedResultsController = [Tutorial MR_fetchAllSortedBy:@"createdAt" ascending:YES withPredicate:self.predicate groupBy:nil delegate:self];
  }
  return _fetchedResultsController;
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTutorialCellReuseIdentifier];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  AssertTrueOrReturn([cell isKindOfClass:[TutorialTableViewCell class]]);
  TutorialTableViewCell *tutorialCell = (TutorialTableViewCell *)cell;
  Tutorial *tutorial = [self.fetchedResultsController objectAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [tutorialCell configureWithTutorial:tutorial];
}

#pragma mark - DataSource - deleting cells

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return self.swipeToDeleteEnabled;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.swipeToDeleteEnabled) {
    // TODO: delete tutorial behaviour should be different on different profile tableView filters - current behaviour is correct only for list of tutorials created by a user
    
    Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
    
    // Make a delete tutorial network request
    [ServerCommunicationController.sharedInstance deleteTutorial:tutorial completion:^(NSError *error) {
      if (error) {
        // TODO: delete tutorial request failed, queue it again, retry
      }
    }];
    
    // Remove tutorial object from CoreData, tableView will automatically pick up the change
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      Tutorial *tutorialInLocalContext = [tutorial MR_inContext:localContext];
      [tutorialInLocalContext MR_deleteInContext:localContext];
    }];
  }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Tutorial *tutorial = [self tutorialAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [self.tutorialTableViewDelegate didSelectRowWithTutorial:tutorial];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static UITableViewCell *sampleCell;
  if (!sampleCell) {
    sampleCell = [[[self nibForTutorialCell] instantiateWithOwner:nil options:nil] lastObject];
  }
  return sampleCell.frame.size.height;
}

#pragma mark - Auxiliary methods

- (Tutorial *)tutorialAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (UINib *)nibForTutorialCell
{
  return [UINib nibWithNibName:kTutorialCellNibName bundle:[NSBundle bundleForClass:[self class]]];
}

#pragma mark - NSFetchedResultsControllerDelegate

// source: http://samwize.com/2014/03/29/implementing-nsfetchedresultscontroller-with-magicalrecord/


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeMove:
    case NSFetchedResultsChangeUpdate:
      break;
  }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

@end
