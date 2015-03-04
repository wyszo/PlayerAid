//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"


@interface TutorialStepTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end


@implementation TutorialStepTableViewCell

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.textView.text = tutorialStep.text;
  self.imageView.image = tutorialStep.image;
  
  // TODO: configure video tutorial step
}

@end
