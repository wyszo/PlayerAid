//
//  PlayerAid
//

#import "PlayerInfoCollectionViewCell.h"
#import <KZAsserts.h>
#import "TWCommonLib.h"


static NSString *const kNibFileName = @"PlayerInfoCollectionViewCell";


@interface PlayerInfoCollectionViewCell ()

@property (strong, nonatomic) UIView *view;
@property (nonatomic, strong) UIColor *defaultBackgroundColor;

@end;


@implementation PlayerInfoCollectionViewCell

#pragma mark - View Initialization

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self customize];
  self.defaultBackgroundColor = self.backgroundColor;
}

- (void)customize
{
  self.topLabel.textColor = [UIColor whiteColor];
  self.bottomLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Class methods

+ (UINib *)nib
{
  UINib *nib = [UINib nibWithNibName:kNibFileName bundle:nil];
  AssertTrueOr(nib, NOOP);
  return nib;
}

#pragma mark - Selection

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  self.backgroundColor = (selected ? self.selectionBackgroundColor : self.defaultBackgroundColor);
}

- (UIColor *)selectionBackgroundColor
{
  if (!_selectionBackgroundColor) {
    _selectionBackgroundColor = [UIColor whiteColor];
  }
  return _selectionBackgroundColor;
}

@end
