//
//  PlayerAid
//

#import "GradientHelper.h"


@implementation GradientHelper

+ (CAGradientLayer *)addGradientLayerToView:(UIView *)view
{
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  gradientLayer.frame = view.bounds;
  UIColor *darkBlue = [UIColor colorWithRed:24.0/255.0 green:45.0/255.0 blue:97.0/255.0 alpha:1.0];
  gradientLayer.colors = @[ (id)[[UIColor colorWithWhite:1.0 alpha:0] CGColor], (id)[darkBlue CGColor] ];
  gradientLayer.shouldRasterize = YES;
  gradientLayer.rasterizationScale = [UIScreen mainScreen].scale;
  
  [view.layer insertSublayer:gradientLayer atIndex:0];
  return gradientLayer;
}

@end
