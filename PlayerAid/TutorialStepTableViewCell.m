//
//  PlayerAid
//

@import KZAsserts;
@import AFNetworking;
@import TWCommonLib;
#import "TutorialStepTableViewCell.h"
#import "TutorialTextStylingHelper.h"

static const CGFloat kContentImageMargin = 0.0f;
static const NSInteger kSeparatorInsetMargin = 8.0f;


@interface TutorialStepTableViewCell ()
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
  self.layoutMargins = UIEdgeInsetsZero; // required for hiding cell separator
  [self setupGestureRecognizers];
}

- (void)setupGestureRecognizers
{
  UITapGestureRecognizer *textViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
  [self.textView addGestureRecognizer:textViewTapGestureRecognizer];
  
  UITapGestureRecognizer *videoTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPlayButtonTapped:)];
  [self.videoPlayButton addGestureRecognizer:videoTapGestureRecognizer];
}

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.tutorialStep = tutorialStep;
  
  self.textView.attributedText = [[TutorialTextStylingHelper new] textStepFormattedAttributedStringFromText:tutorialStep.text];
  self.videoPlayImage.hidden = YES;
  [self updateImageViewWithTutorialStep:tutorialStep];
  [self updateSeparatorVisibility];
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
      if (tutorialStep.videoThumbnailData) {
        self.contentImageView.image = [UIImage imageWithData:tutorialStep.videoThumbnailData];
      } else {
        // no local video - download from web
        NSURL *thumbnailUrl = [NSURL URLWithString:tutorialStep.serverVideoThumbnailUrl];
        AssertTrueOr(thumbnailUrl,);
        [self.contentImageView setImageWithURL:thumbnailUrl];
      }
        
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
  
  [self.contentImageView cancelImageRequestOperation];
  [self showSeparator];
}

- (void)hideImageView
{
  self.contentImageHeightAndWidthConstraint.constant = 0.0f;
  self.contentImageView.image = nil;
  [self layoutIfNeeded];
}

#pragma mark - Separator visibility

- (void)updateSeparatorVisibility
{
  if (self.tutorialStep.isTextStep) {
    [self showSeparator];
  } else {
    [self tw_hideSeparator];
  }
}

- (void)showSeparator
{
  [self tw_showSeparatorWithMarginInset:kSeparatorInsetMargin];
}

#pragma mark - Actions

- (void)videoPlayButtonTapped:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(didPressPlayVideoWithURL:)]) {
    [self.delegate didPressPlayVideoWithURL:self.videoURL];
  }
}

- (void)textViewTapped:(id)sender
{
  if ([self isTextType]) {
    AssertTrueOrReturn(self.tutorialStep);
    if ([self.delegate respondsToSelector:@selector(didPressTextViewWithStep:)]) {
      [self.delegate didPressTextViewWithStep:self.tutorialStep];
    }
  }
}

#pragma mark - Accessors

- (BOOL)isTextType
{
  return (self.textView.text.length > 0);
}

@end
