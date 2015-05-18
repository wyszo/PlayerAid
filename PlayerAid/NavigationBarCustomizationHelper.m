//
//  PlayerAid
//

#import "NavigationBarCustomizationHelper.h"


@implementation NavigationBarCustomizationHelper

+ (UIView *)containerViewhWithButtonWithFrame:(CGRect)frame title:(NSString *)buttonTitle target:(id)target action:(SEL)action
{
  UIView *buttonContainer = [[UIView alloc] initWithFrame:frame];
  
  UIButton *button = [[UIButton alloc] initWithFrame:frame];
  button.backgroundColor = [UIColor clearColor];
  [button setTitle:buttonTitle forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
  button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  [buttonContainer addSubview:button];
  
  return buttonContainer;
}

@end