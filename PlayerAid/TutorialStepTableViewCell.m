//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"


static const CGFloat kContentImageHeight = 270.0f;


@interface TutorialStepTableViewCell () <NSLayoutManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *videoPlayLabel;

@end


@implementation TutorialStepTableViewCell

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.textView.layoutManager.delegate = self;
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
    [self hideImageView];
  }
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  [self hideImageView];
  self.videoPlayLabel.hidden = YES;
  self.textView.text = @"";
}

- (void)hideImageView
{
  self.contentImageHeightConstraint.constant = 0.0f;
  self.contentImageView.image = nil;
  [self layoutIfNeeded];
}

#pragma mark - NSLayoutManagerDelegate

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
  return 10.0f;
}

@end
