//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import MagicalRecord;
#import "TutorialStepsDataSourceDelegate.h"
#import "MediaPlayerHelper.h"
#import "AlertFactory.h"
#import "TutorialStep.h"
#import "Tutorial.h"
#import "TutorialStepTableViewCell.h"
#import "UITableView+TableViewHelper.h"


static NSString *const kTutorialStepCellNibName = @"TutorialStepTableViewCell";
static NSString *const kTutorialStepCellReuseIdentifier = @"TutorialStepCell";


@interface TutorialStepsDataSourceDelegate () <UITableViewDelegate>

@property (nonatomic, strong) TWCoreDataTableViewDataSource *tableViewDataSource;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, weak) id<TutorialStepTableViewCellDelegate> cellDelegate; 

@end


@implementation TutorialStepsDataSourceDelegate

#pragma mark - Initilization

- (void)initFRC {
    defineWeakSelf();
    self.tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = ^() {
        AssertTrueOr(weakSelf.tutorial, ;);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"belongsTo == %@", weakSelf.tutorial];
        return [TutorialStep MR_fetchAllSortedBy:@"order"
                                       ascending:YES
                                   withPredicate:predicate
                                         groupBy:nil
                                        delegate:nil //weakSelf.fetchedResultsControllerBinder
                                       inContext:weakSelf.context];
    };
}

// TODO: it's confusing that you don't set this class as a tableView dataSource and you just initialize it. Need to document it! 
- (instancetype)initWithTableView:(UITableView *)tableView
                         tutorial:(Tutorial *)tutorial
                          context:(NSManagedObjectContext *)context
                    allowsEditing:(BOOL)allowsEditing
tutorialStepTableViewCellDelegate:(id<TutorialStepTableViewCellDelegate>)cellDelegate
{
  AssertTrueOrReturnNil(tableView);
  AssertTrueOrReturnNil(tutorial);
  
  self = [super init];
  if (self) {
    _tableView = tableView;
    _tableView.delegate = self;
    _tutorial = tutorial;
    _context = context;
    _allowsEditing = allowsEditing;
    _cellDelegate = cellDelegate;
    
    [_tableView registerNibWithName:kTutorialStepCellNibName forCellReuseIdentifier:kTutorialStepCellReuseIdentifier];
    
    [self initTableViewDataSource];
  }
  return self;
}

// to nie jest za wczesnie tworzone?? - nie chyba, ale trzeba jeszcze reload data dac przed pokazaniem...
- (void)initTableViewDataSource
{
  defineWeakSelf();
  
  self.tableViewDataSource = [[TWCoreDataTableViewDataSource alloc] initWithCellReuseIdentifier:kTutorialStepCellReuseIdentifier
                                                                             configureCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
    AssertTrueOrReturn([cell isKindOfClass:[TutorialStepTableViewCell class]]);
    TutorialStepTableViewCell *tutorialStepCell = (TutorialStepTableViewCell *)cell;
    
    [weakSelf configureCell:tutorialStepCell atIndexPath:indexPath];
    [weakSelf updateSeparatorVisiblityForCell:tutorialStepCell atIndexPath:indexPath];
  }];
  
  self.tableView.dataSource = _tableViewDataSource;
}

- (void)configureCell:(nonnull TutorialStepTableViewCell *)tutorialStepCell atIndexPath:(nonnull NSIndexPath *)indexPath
{
  AssertTrueOrReturn(tutorialStepCell);
  AssertTrueOrReturn(indexPath);
  
  // tu jest problem troche ze na tym etapie cellka nie jest jeszcze dodana do widoku...
  TutorialStep *tutorialStep = [self.tableViewDataSource objectAtIndexPath:indexPath];
  [tutorialStepCell configureWithTutorialStep:tutorialStep];
  tutorialStepCell.delegate = self.cellDelegate;
  
  [self updateSeparatorVisiblityForCell:tutorialStepCell atIndexPath:indexPath];
}

#pragma mark - Auxiliary methods

- (void)updateSeparatorVisiblityForCell:(nonnull UITableViewCell *)tutorialStepCell atIndexPath:(nonnull NSIndexPath *)indexPath
{
  AssertTrueOrReturn(tutorialStepCell);
  AssertTrueOrReturn(indexPath);
  
  if ([self objectForNextIndexPathIsTextStep:indexPath]) {
    [tutorialStepCell tw_hideSeparator];
  }
}

- (BOOL)objectForNextIndexPathIsTextStep:(nonnull NSIndexPath *)indexPath
{
  AssertTrueOrReturnNo(indexPath);
  
  NSInteger lastObjectIndex = (self.tableViewDataSource.objectCount - 1);
  if (indexPath.row != lastObjectIndex) {
    NSIndexPath *nextIndexPath = [indexPath tw_nextRowIndexPath];
    id nextObject = [self.tableViewDataSource objectAtIndexPath:nextIndexPath];
    AssertTrueOrReturnNo([nextObject isKindOfClass:[TutorialStep class]]);
    TutorialStep *nextTutorialStep = (TutorialStep *)nextObject;
    
    if (!nextTutorialStep.isTextStep) {
      return YES;
    }
  }
  return NO;
}

#pragma mark - Context

- (NSManagedObjectContext *)context
{
  if (!_context) {
    return [NSManagedObjectContext MR_defaultContext];
  }
  return _context;
}

#pragma mark - Playing a video

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  TutorialStep *tutorialStep = [_tableViewDataSource objectAtIndexPath:indexPath];

  if (tutorialStep.videoPath) {
    NSURL *url = [NSURL URLWithString:tutorialStep.videoPath];
    [MediaPlayerHelper playVideoWithURL:url fromViewController:self.moviePlayerParentViewController];
  }
}

@end
