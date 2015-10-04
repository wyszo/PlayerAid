//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import "TutorialStep.h"
#import <TWCommonLib/TWCommonTypes.h>


@interface EditTutorialTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) VoidBlock deleteCellBlock;

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep;

@end
