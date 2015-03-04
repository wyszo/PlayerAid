//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"


static const CGFloat kContentImageHeight = 270.0f;


@interface TutorialStepTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *videoPlayLabel;

@end


@implementation TutorialStepTableViewCell

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.textView.text = tutorialStep.text;
  self.videoPlayLabel.hidden = YES;
  [self updateImageViewWithTutorialStep:tutorialStep];
}

- (void)updateImageViewWithTutorialStep:(TutorialStep *)tutorialStep
{
  BOOL imageTutorialStep = (tutorialStep.image != nil);
  BOOL videoTutorialStep = (tutorialStep.videoPath.length != 0);
  
  if (imageTutorialStep || videoTutorialStep) {
    self.contentImageHeightConstraint.constant = kContentImageHeight;
    
    if (imageTutorialStep) {
      self.contentImageView.image = tutorialStep.image;
    }
    else if (videoTutorialStep) {
      self.contentImageView.image = [UIImage imageWithData:tutorialStep.videoThumbnailData];
      self.videoPlayLabel.hidden = NO;
    }
  }
  else {
    self.contentImageHeightConstraint.constant = 0.0f;
    self.contentImageView.image = nil;
  }
}

@end
