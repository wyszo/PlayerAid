//
//  PlayerAid
//


#import "ShowOverlayViewWhenTutorialsTableEmptyBehaviour.h"
#import "TutorialsTableDataSource.h"


@interface ShowOverlayViewWhenTutorialsTableEmptyBehaviour ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) TutorialsTableDataSource *dataSource;
@property (nonatomic, weak) UIView *overlayView;
@property (nonatomic, assign) BOOL allowScrollingWhenNoCells;

@end


@implementation ShowOverlayViewWhenTutorialsTableEmptyBehaviour

- (instancetype)initWithTableView:(UITableView *)tableView tutorialsDataSource:(TutorialsTableDataSource *)tutorialsDataSource overlayView:(UIView *)overlayView allowScrollingWhenNoCells:(BOOL)allowScrollingWhenNoCells
{
  self = [super init];
  if (self) {
    _tableView = tableView;
    _dataSource = tutorialsDataSource;
    _overlayView = overlayView;
    _allowScrollingWhenNoCells = allowScrollingWhenNoCells;
  }
  return self;
}

- (void)updateTableViewScrollingAndOverlayViewVisibility
{
  AssertTrueOrReturn(self.tableView);
  AssertTrueOrReturn(self.dataSource);
  AssertTrueOrReturn(self.overlayView);
  
  if ([self.dataSource totalNumberOfCells] == 0) {
    if ([self altersScrollingBehaviour]) {
      self.tableView.scrollEnabled = NO;
    }
    self.overlayView.hidden = NO;
  }
  else {
    if ([self altersScrollingBehaviour]) {
      self.tableView.scrollEnabled = YES;
    }
    self.overlayView.hidden = YES;
  }
}

- (BOOL)altersScrollingBehaviour
{
  return (self.allowScrollingWhenNoCells == NO);
}

@end
