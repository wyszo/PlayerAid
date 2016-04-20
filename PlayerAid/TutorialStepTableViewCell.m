//
//  PlayerAid
//

@import KZAsserts;
@import AFNetworking;
@import TWCommonLib;
#import "TutorialStepTableViewCell.h"
#import "TutorialTextStylingHelper.h"
#import "ColorsHelper.h"
#import "UIImageView+AFNetworkingImageView.h"
#import "VideoDurationFormatter.h"

static const CGFloat kContentImageMargin = 8.0f;
static const NSInteger kSeparatorInsetMargin = 8.0f;


@interface TutorialStepTableViewCell ()
@property (strong, nonatomic) TutorialStep *tutorialStep;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentTypeIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewImageAspectConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewVideoAspectConstraint;
@property (weak, nonatomic) IBOutlet UIView *videoOverlayContainer;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
@property (weak, nonatomic) IBOutlet UILabel *videoLengthLabel;
@property (strong, nonatomic) NSURL *videoURL;

@property (copy, nonatomic) BlockWithBoolParameter imageLoadedCompletionBlock;
@end


@implementation TutorialStepTableViewCell

#pragma mark - View Customization

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self setupLayout];
  [self setupGestureRecognizers];
}

- (void)setupLayout {
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.layoutMargins = UIEdgeInsetsZero; // required for hiding cell separator
  [self.contentContainerView tw_setCornerRadius:5.0];
  self.contentImageView.backgroundColor = [ColorsHelper tutorialImageBackgroundColor];
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
  
  self.videoOverlayContainer.hidden = YES;
  [self updateTextWithTutorialStep:tutorialStep];
  [self updateImageViewWithTutorialStep:tutorialStep];
  [self updateSeparatorVisibility];
}

- (void)updateTextWithTutorialStep:(TutorialStep *)tutorialStep
{
  AssertTrueOrReturn(tutorialStep);
  NSString *text;
  if ([self.tutorialStep isTextStep]) {
    text = self.tutorialStep.text;
  }
  if (!text.length) {
    text = @"";
  }
  self.textView.attributedText = [[TutorialTextStylingHelper new] textStepFormattedAttributedStringFromText:text];
}

- (void)updateImageViewWithTutorialStep:(TutorialStep *)tutorialStep
{
  BOOL imageTutorialStep = [tutorialStep isImageStep];
  BOOL videoTutorialStep = [tutorialStep isVideoStep];
  
  if (imageTutorialStep || videoTutorialStep) {
    [self switchToImageContentViewConstraint];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentImageWidthConstraint.constant = screenWidth - (kContentImageMargin * 2);
    
    if (imageTutorialStep) {
      [self showContentTypePlaceholderImageNamed:@"photoCam"];
      [tutorialStep placeImageInImageView:self.contentImageView completion:self.imageLoadedCompletionBlock];
    }
    else if (videoTutorialStep) {
      [self switchToVideoContentViewConstraint];
    
      VoidBlock ShowVideoIconAndButtonBlock = ^() {
        self.videoOverlayContainer.hidden = NO;
        self.videoPlayButton.hidden = NO;
      };
      
      if (tutorialStep.videoThumbnailData) {
        self.contentImageView.image = [UIImage imageWithData:tutorialStep.videoThumbnailData];
        ShowVideoIconAndButtonBlock();
      } else {
        [self showContentTypePlaceholderImageNamed:@"videoCam"];

        // no local video - download from web
        NSURL *thumbnailUrl = [NSURL URLWithString:tutorialStep.serverVideoThumbnailUrl];
        AssertTrueOr(thumbnailUrl,);
        [self.contentImageView setImageWithURL:thumbnailUrl completion:^(BOOL success) {
          if (success) {
            CallBlock(self.imageLoadedCompletionBlock, success);
            ShowVideoIconAndButtonBlock();
          }
        }];
      }
      self.videoURL = [NSURL URLWithString:tutorialStep.videoPath];
      self.videoLengthLabel.text = [[VideoDurationFormatter new] formatDurationInSeconds:(NSTimeInterval)tutorialStep.videoDurationInSecondsValue];
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
  self.videoOverlayContainer.hidden = YES;
  self.textView.text = @"";
  self.textView.attributedText = [NSAttributedString new];
  self.videoURL = nil;
  self.videoPlayButton.hidden = YES;
  self.contentTypeIconImageView.hidden = YES;
  self.videoLengthLabel.text = @"";
  
  [self switchToImageContentViewConstraint];
  [self.contentImageView cancelImageRequestOperation];
  [self showSeparator];
}

- (void)hideImageView
{
  self.contentImageWidthConstraint.constant = 0.0f;
  self.contentImageView.image = nil;
  [self layoutIfNeeded];
}

#pragma mark - Separator visibility

- (void)updateSeparatorVisibility {
  if (self.tutorialStep.isTextStep) {
    [self showSeparator];
  } else {
    [self tw_hideSeparator];
  }
}

- (void)showSeparator {
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

- (BOOL)isTextType {
  return (self.textView.text.length > 0);
}

- (BlockWithBoolParameter)imageLoadedCompletionBlock {
  return ^(BOOL success) {
    self.contentTypeIconImageView.hidden = YES;
  };
}

#pragma mark - Auxiliary methods

- (void)showContentTypePlaceholderImageNamed:(NSString *)imageName {
  AssertTrueOrReturn(imageName.length);
  
  self.contentTypeIconImageView.image = [UIImage imageNamed:imageName];
  self.contentTypeIconImageView.hidden = NO;
}

#pragma mark - Constraints

- (void)switchToImageContentViewConstraint {
  self.contentViewImageAspectConstraint.active = YES;
  self.contentViewVideoAspectConstraint.active = NO;
}

- (void)switchToVideoContentViewConstraint {
  self.contentViewImageAspectConstraint.active = NO;
  self.contentViewVideoAspectConstraint.active = YES;
}

@end
