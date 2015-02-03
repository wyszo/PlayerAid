//
//  PlayerAid
//

#import <CoreData/CoreData.h>
#import <NSManagedObject+MagicalFinders.h>
#import <KZAsserts.h>
#import "TutorialsTableDataSource.h"
#import "Tutorial.h"
#import "TutorialTableViewCell.h"

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
    
    [self initializeFetchedResultsController];
  }
  return self;
}

- (void)initializeFetchedResultsController
{
  // perform fetch
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"draft = NO or draft = nil"];
  self.fetchedResultsController = [Tutorial MR_fetchAllSortedBy:@"createdAt" ascending:YES withPredicate:predicate groupBy:nil delegate:self];
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TutorialCell"];
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

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Tutorial *tutorial = [self.fetchedResultsController objectAtIndexPath:indexPath];
  AssertTrueOrReturn(tutorial);
  [self.tutorialTableViewDelegate didSelectRowWithTutorial:tutorial];
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
