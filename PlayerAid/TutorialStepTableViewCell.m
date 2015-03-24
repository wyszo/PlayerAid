//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"


// TODO: this should be read from xib file, not set programatically, confusing!!
static const CGFloat kContentImageHeight = 180.0f;


@interface TutorialStepTableViewCell () <NSLayoutManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;

@end


@implementation TutorialStepTableViewCell

#pragma mark - View Customization

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.textView.layoutManager.delegate = self;
  self.textView.text = tutorialStep.text;
  self.videoPlayImage.hidden = YES;
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
      self.videoPlayImage.hidden = NO;
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
  self.videoPlayImage.hidden = YES;
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
