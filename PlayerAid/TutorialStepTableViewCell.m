//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"


@interface TutorialStepTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end


@implementation TutorialStepTableViewCell

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.textView.text = tutorialStep.text;
}

@end
