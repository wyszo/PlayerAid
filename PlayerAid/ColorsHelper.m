//
//  PlayerAid
//

#import "ColorsHelper.h"

#define UIColorMake(r,g,b) [UIColor colorWithRed:((CGFloat)r)/255.0 green:((CGFloat)g)/255.0 blue:((CGFloat)b)/255 alpha:1.0];


@implementation ColorsHelper

+ (UIColor *)tabBarSelectedTextColor
{
  return UIColorMake(43, 72, 134);
}

+ (UIColor *)tabBarUnselectedTextColor
{
  return UIColorMake(158, 171, 199);
}

+ (UIColor *)tabBarCreateTutorialBackgroundColor
{
  return UIColorMake(43, 72, 134);
}

@end
