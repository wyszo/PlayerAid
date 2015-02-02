//
//  PlayerAid
//

#import "TutorialsTableDataSourceDelegate.h"


@implementation TutorialsTableDataSourceDelegate

#pragma mark - Initilization

- (instancetype)initWithTableView:(UITableView *)tableView
{
  self = [super init];
  if (self) {
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelection = NO;
  }
  return self;
}

#pragma mark - Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TutorialCell"];
  
  // TODO: cell customisation
  
  return cell;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // TODO: implement action handling - show full tutorial view
}

@end
