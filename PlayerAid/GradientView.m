//
//  PlayerAid
//

#import "GradientView.h"
#import "ColorsHelper.h"

@implementation GradientView

#pragma mark - Initialization

+ (Class)layerClass
{
  return [CAGradientLayer class];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.gradientLayer.shouldRasterize = YES;
  self.gradientLayer.rasterizationScale = [UIScreen mainScreen].scale;
  
  if (self.gradientColors) {
    self.gradientLayer.colors = self.gradientColors;
  }
  else {
    [self setDefaultGradientColors];
  }
}

- (void)setDefaultGradientColors
{
  UIColor *whiteTransparent = [UIColor colorWithWhite:1.0 alpha:0];
  UIColor *darkBlue = [ColorsHelper tutorialGradientBlueColor];
  self.gradientLayer.colors = @[ (id)[whiteTransparent CGColor], (id)[darkBlue CGColor] ];
}

#pragma mark - Public

- (void)setGradientColors:(NSArray *)gradientColors
{
  if (gradientColors && gradientColors != _gradientColors) {
    NSMutableArray *cgColorsArray = [NSMutableArray new];
    
    for (UIColor *color in gradientColors) {
      [cgColorsArray addObject:(id)[color CGColor]];
    }
    _gradientColors = [cgColorsArray copy];
  }
}

#pragma mark - Accessors

- (CAGradientLayer *)gradientLayer
{
  return (CAGradientLayer *)self.layer;
}

@end
