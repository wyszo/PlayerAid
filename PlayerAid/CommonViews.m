//
//  PlayerAid
//


#import "CommonViews.h"

@implementation CommonViews

+ (UIView *)smallTransparentTableFooterView
{
  UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
  footer.backgroundColor = [UIColor clearColor];
  return footer;
}

@end
