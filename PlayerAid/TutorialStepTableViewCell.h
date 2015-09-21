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
@optional
- (void)didPressPlayVideoWithURL:(NSURL *)url;
- (void)didPressTextViewWithStep:(TutorialStep *)tutorialTextStep;
@end
