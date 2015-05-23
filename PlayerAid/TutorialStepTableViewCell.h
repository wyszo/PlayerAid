//
//  PlayerAid
//

#import "TutorialStep.h"


@protocol TutorialStepTableViewCellDelegate;


@interface TutorialStepTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TutorialStepTableViewCellDelegate> delegate;

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep;

@end


@protocol TutorialStepTableViewCellDelegate <NSObject>
- (void)didPressPlayVideoWithURL:(NSURL *)url;
@end
