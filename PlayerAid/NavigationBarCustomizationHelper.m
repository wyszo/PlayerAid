//
//  PlayerAid
//

#import "NavigationBarCustomizationHelper.h"
#import "FontsHelper.h"


@implementation NavigationBarCustomizationHelper

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
  UIButton *button = [[UIButton alloc] initWithFrame:frame];
  button.backgroundColor = [UIColor clearColor];
  
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.font = [FontsHelper navbarButtonsFont];
  [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
  
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  return button;
}

@end