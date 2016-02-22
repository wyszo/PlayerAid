@import KZAsserts;
@import TWCommonLib;
#import "CommentRepliesCellConfigurator.h"
#import "CommonViews.h"

@implementation CommentRepliesCellConfigurator

#pragma mark - Public

- (UIView *)moreRepliesBarWithPressedActionTarget:(id)target selector:(SEL)selector {
  const NSInteger kMoreRepliesHeaderHeight = 34;
  
  UIView *headerView = [UIView tw_viewFromNibNamed:@"MoreRepliesBar" withOwner:nil];
  headerView.frame = CGRectMake(0, 0, UIScreen.tw_width, kMoreRepliesHeaderHeight);
  
  UIButton *button = [self firstButtonFromArray:headerView.subviews];
  [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  
  return headerView;
}

- (UIView *)dummyHeaderView {
  return [CommonViews smallTableHeaderOrFooterView];
}

#pragma mark - Private

- (UIButton *)firstButtonFromArray:(NSArray *)views {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [UIButton class]];
  NSArray *buttons = [views filteredArrayUsingPredicate:predicate];
  AssertTrueOrReturnNil(buttons.count >= 1);
  return buttons[0];
}

@end