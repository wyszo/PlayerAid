//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "PlayerInfoCollectionViewCell.h"

static NSString *const kNibFileName = @"PlayerInfoCollectionViewCell";


@interface PlayerInfoCollectionViewCell ()

@property (strong, nonatomic) UIView *view;
@property (nonatomic, strong) UIColor *defaultBackgroundColor;
@property (weak, nonatomic) IBOutlet UIView *selectionIndicatorView;

@end;


@implementation PlayerInfoCollectionViewCell
@synthesize selectionBackgroundColor = _selectionBackgroundColor;

#pragma mark - View Initialization

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self customize];
  self.defaultBackgroundColor = [UIColor clearColor];
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
  
  self.selectionIndicatorView.backgroundColor = (selected ? self.selectionBackgroundColor : self.defaultBackgroundColor);
  
    UIColor *textColor = (selected ? self.selectedTextColor : self.unselectedTextColor);
    self.topLabel.textColor = textColor;
    self.bottomLabel.textColor = textColor;
}

- (UIColor *)selectionBackgroundColor
{
  if (!_selectionBackgroundColor) {
    _selectionBackgroundColor = [UIColor whiteColor];
  }
  return _selectionBackgroundColor;
}

- (void)setSelectionBackgroundColor:(UIColor *)selectionBackgroundColor
{
  _selectionBackgroundColor = selectionBackgroundColor;
  [self setSelected:self.selected];
}

#pragma mark - Accessors

- (UIColor *)selectedTextColor {
    if (!_selectedTextColor) {
        _selectedTextColor = [UIColor whiteColor];
    }
    return _selectedTextColor;
}

- (UIColor *)unselectedTextColor {
    if (!_unselectedTextColor) {
        _unselectedTextColor = [UIColor whiteColor];
    }
    return _unselectedTextColor;
}

@end
