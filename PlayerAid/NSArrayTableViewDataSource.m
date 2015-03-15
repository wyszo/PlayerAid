//
//  PlayerAid
//

#import "NSArrayTableViewDataSource.h"


static NSString *const kCellDequeueIdentifier = @"cell";


@interface NSArrayTableViewDataSource ()

@property (strong, nonatomic) NSMutableArray *array;
@property (weak, nonatomic) UITableView *tableView;

@end


@implementation NSArrayTableViewDataSource

- (instancetype)initWithArray:(NSArray *)array tableView:(UITableView *)tableView tableViewCellNibName:(NSString *)cellNibName
{
  AssertTrueOrReturnNil(array);
  AssertTrueOrReturnNil(tableView);
  AssertTrueOrReturnNil(cellNibName);
  
  if (self = [super init]) {
    _array = [array mutableCopy];
    _tableView = tableView;
    
    UINib *tableViewCellNib = [UINib nibWithNibName:cellNibName bundle:[NSBundle bundleForClass:[self class]]];
    [_tableView registerNib:tableViewCellNib forCellReuseIdentifier:kCellDequeueIdentifier];
  }
  return self;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//  AssertTrueOrReturn(NO); // NOT IMPELEMENTED YET!
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellDequeueIdentifier];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

#pragma mark - moving cells

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return NO; // TOOD: parametrize this!!
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  AssertTrueOrReturn(sourceIndexPath.row < self.array.count);
  AssertTrueOrReturn(destinationIndexPath.row < self.array.count);
  
  [self.array exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

@end
