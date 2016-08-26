//
//  PlayerAid
//

@import UIKit;
@import Foundation;

@interface PlayerInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (strong, nonatomic) UIColor *selectedTextColor;
@property (strong, nonatomic) UIColor *unselectedTextColor;

/**
 Defaults to white if not set
 */
@property (strong, nonatomic) UIColor *selectionBackgroundColor;

+ (UINib *)nib;

@end
