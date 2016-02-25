@import KZAsserts;
@import TWCommonLib;
#import "CommentRepliesCellConfigurator.h"
#import "CommonViews.h"
#import "ColorsHelper.h"

@implementation CommentRepliesCellConfigurator

#pragma mark - Public

- (UIView *)moreRepliesBarWithPressedActionTarget:(id)target selector:(SEL)selector {
  const NSInteger kMoreRepliesHeaderHeight = 34;
  
  UIView *headerView = [UIView tw_viewFromNibNamed:@"MoreRepliesBar" withOwner:nil];
  headerView.frame = CGRectMake(0, 0, UIScreen.tw_width, kMoreRepliesHeaderHeight);
  
  UIButton *button = [self firstButtonFromArray:headerView.subviews];
  [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  
  UIView *separatorView = [self separatorViewFromSuperview:headerView];
  [self setupSeparatorView:separatorView];
  
  return headerView;
}

- (UIView *)dummyHeaderView {
  UIView *simulatedSeparator = [CommonViews smallTableHeaderOrFooterView];
  simulatedSeparator.tw_height = 0.5;
  simulatedSeparator.backgroundColor = [ColorsHelper commentsSeparatorColor];
  return simulatedSeparator;
}

#pragma mark - Private

- (UIButton *)firstButtonFromArray:(NSArray *)views {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [UIButton class]];
  NSArray *buttons = [views filteredArrayUsingPredicate:predicate];
  AssertTrueOrReturnNil(buttons.count >= 1);
  return buttons[0];
}

#pragma mark - Separator setup

- (UIView *)separatorViewFromSuperview:(UIView *)separatorParentView {
  AssertTrueOrReturnNil(separatorParentView);
  
  const NSInteger kSeparatorViewTag = 567;
  NSArray *filteredSubviews = [separatorParentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %d", kSeparatorViewTag]];
  AssertTrueOrReturnNil(filteredSubviews.count == 1);
  UIView *separatorView = filteredSubviews[0];
  return separatorView;
}

- (void)setupSeparatorView:(UIView *)separatorView {
  AssertTrueOrReturn(separatorView);
  separatorView.backgroundColor = [ColorsHelper commentsSeparatorColor];
  separatorView.tw_height = 0.5;
}

@end