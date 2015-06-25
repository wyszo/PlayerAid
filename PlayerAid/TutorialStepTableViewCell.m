//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"

static const CGFloat kContentImageMargin = 7.0f;


@interface TutorialStepTableViewCell () <NSLayoutManagerDelegate>

@property (strong, nonatomic) TutorialStep *tutorialStep;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeightAndWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
@property (strong, nonatomic) NSURL *videoURL;

@end


@implementation TutorialStepTableViewCell

#pragma mark - View Customization

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self setupGestureRecognizers];
}

- (void)setupGestureRecognizers
{
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
  [self.textView addGestureRecognizer:tapGestureRecognizer];
}

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.tutorialStep = tutorialStep;
  
  self.textView.layoutManager.delegate = self;
  self.textView.text = tutorialStep.text;
  self.videoPlayImage.hidden = YES;
  [self updateImageViewWithTutorialStep:tutorialStep];
}

- (void)updateImageViewWithTutorialStep:(TutorialStep *)tutorialStep
{
  BOOL imageTutorialStep = [tutorialStep isImageStep];
  BOOL videoTutorialStep = [tutorialStep isVideoStep];
  
  if (imageTutorialStep || videoTutorialStep) {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentImageHeightAndWidthConstraint.constant = screenWidth - (kContentImageMargin * 2);
    
    if (imageTutorialStep) {
      [tutorialStep placeImageInImageView:self.contentImageView];
    }
    else if (videoTutorialStep) {
      self.contentImageView.image = [UIImage imageWithData:tutorialStep.videoThumbnailData];
      self.videoPlayImage.hidden = NO;
      self.videoPlayButton.hidden = NO;
      self.videoURL = [NSURL URLWithString:tutorialStep.videoPath];
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
  self.videoURL = nil;
  self.videoPlayButton.hidden = YES;
}

- (void)hideImageView
{
  self.contentImageHeightAndWidthConstraint.constant = 0.0f;
  self.contentImageView.image = nil;
  [self layoutIfNeeded];
}

#pragma mark - NSLayoutManagerDelegate

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
  return 10.0f;
}

- (IBAction)videoPlayButtonPressed:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(didPressPlayVideoWithURL:)]) {
    [self.delegate didPressPlayVideoWithURL:self.videoURL];
  }
}

#pragma mark - Actions

- (void)textViewTapped:(id)sender
{
  if ([self isTextType]) {
    AssertTrueOrReturn(self.tutorialStep);
    if ([self.delegate respondsToSelector:@selector(didPressTextViewWithStep:)]) {
      [self.delegate didPressTextViewWithStep:self.tutorialStep];
    }
  }
}

- (BOOL)isTextType
{
  return (self.textView.text.length > 0);
}

@end
