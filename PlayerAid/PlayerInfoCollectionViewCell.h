//
//  PlayerAid
//

@interface PlayerInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

/**
 Defaults to white if not set
 */
@property (strong, nonatomic) UIColor *selectionBackgroundColor;

+ (UINib *)nib;

@end
