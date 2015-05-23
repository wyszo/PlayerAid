//
//  PlayerAid
//

#import "TableViewBasicDelegateObject.h"


@interface TableViewBasicDelegateObject()

@property (nonatomic, assign) CGFloat cellHeight;

@end


@implementation TableViewBasicDelegateObject

- (instancetype)initWithCellHeight:(CGFloat)cellHeight
{
  self = [super init];
  if (self) {
    _cellHeight = cellHeight;
  }
  return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return self.cellHeight;
}

@end
