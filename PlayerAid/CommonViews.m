#import "CommonViews.h"

@implementation CommonViews

+ (UIView *)smallTableHeaderOrFooterView {
  return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
}

+ (UIView *)tableHeaderOrFooterViewWithHeight:(CGFloat)height {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
}

@end
