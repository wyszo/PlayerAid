//
//  PlayerAid
//

#import "TutorialStep.h"


@interface EditTutorialTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep;

@end
