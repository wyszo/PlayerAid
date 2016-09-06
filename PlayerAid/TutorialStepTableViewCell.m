//
//  PlayerAid
//

@import KZAsserts;
@import AFNetworking;
@import TWCommonLib;
@import RichEditorView;
#import "TutorialStepTableViewCell.h"
#import "TutorialTextStylingHelper.h"
#import "ColorsHelper.h"
#import "UIImageView+AFNetworkingImageView.h"
#import "VideoDurationFormatter.h"

static const CGFloat kContentImageMargin = 8.0f;
static const NSInteger kSeparatorInsetMargin = 8.0f;


@interface TutorialStepTableViewCell () <RichEditorDelegate>
@property (strong, nonatomic) TutorialStep *tutorialStep;

@property (weak, nonatomic) IBOutlet RichEditorView *editorView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editorViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentTypeIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeightConstraint;
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
  [self setupEditorView];
  
  
//  self.backgroundColor = [UIColor blueColor];
  
    // workaround...
    [self prepareForReuse];
}

- (void)setupEditorView {
  self.editorView.delegate = self;
  self.editorView.editingEnabled = false;
  self.editorView.scrollEnabled = false;
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
  [self.editorView addGestureRecognizer:textViewTapGestureRecognizer];
  
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
    text = [self htmlStringFromText:self.tutorialStep.text];
  }
  if (!text.length) {
    text = @"";
  }
  [self.editorView setHTML:text];
  
    // ..
    self.editorViewHeightConstraint.constant = self.editorView.editorHeight;
}



    // TODO: extract this method from here
    - (NSString *)cssStyle {
        NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"TextStep" ofType:@"css"];
        return [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
    }

    // TODO: extract this method from here
    - (NSString *)htmlStringFromText:(NSString *)text {
        return [NSString stringWithFormat:@"<style type='text/css'>%@</style><body>%@</body>", [self cssStyle], text];
    }


- (void)updateImageViewWithTutorialStep:(TutorialStep *)tutorialStep
{
  BOOL imageTutorialStep = [tutorialStep isImageStep];
  BOOL videoTutorialStep = [tutorialStep isVideoStep];

  self.contentImageView.contentMode = UIViewContentModeScaleToFill;

  if (imageTutorialStep || videoTutorialStep) {
    [self setupImageViewConstriants];
    
    if (imageTutorialStep) {
      [self showContentTypePlaceholderImageNamed:@"photoCam"];
      [tutorialStep placeImageInImageView:self.contentImageView completion:self.imageLoadedCompletionBlock];
    }
    else if (videoTutorialStep) {
      [self switchToVideoContentViewConstraint];
      self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    
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
  [self.editorView setHTML:@""];
  self.videoURL = nil;
  self.videoPlayButton.hidden = YES;
  self.contentTypeIconImageView.hidden = YES;
  self.videoLengthLabel.text = @"";

  [self.contentImageView cancelImageRequestOperation];
  [self showSeparator];
}

- (void)hideImageView
{
  self.contentImageWidthConstraint.constant = 0.0f;
  self.contentImageHeightConstraint.constant = 0.0f;
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
  return ([self.editorView getText].length > 0);
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

- (void)setupImageViewConstriants {
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  CGFloat imageSize = screenWidth - (kContentImageMargin * 2);
  
  self.contentImageWidthConstraint.constant = imageSize;
  self.contentImageHeightConstraint.constant = imageSize;
}

- (void)switchToVideoContentViewConstraint {
  self.contentImageHeightConstraint.constant = 0.5 * self.contentImageWidthConstraint.constant;
}

#pragma mark - RichEditorDelegate

- (void)richEditor:(RichEditorView *)editor heightDidChange:(NSInteger)height {
    NSLog(@"height: %ld", height);
    AssertTrueOrReturn(self.editorViewHeightConstraint != nil);
    
  self.editorViewHeightConstraint.constant = height;
}

@end
