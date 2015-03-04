//
//  PlayerAid
//

#import "TutorialStepTableViewCell.h"


static const CGFloat kContentImageHeight = 270.0f;


@interface TutorialStepTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeightConstraint;

// obsolete
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewAspectRatioConstraint;
@end


@implementation TutorialStepTableViewCell

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  self.textView.text = tutorialStep.text;
  [self updateImageViewWithImage:tutorialStep.image];
  
  // TODO: configure video tutorial step
}

- (void)updateImageViewWithImage:(UIImage *)image
{
  self.contentImageView.image = image;
  self.contentImageHeightConstraint.constant = (image ? kContentImageHeight : 0.0f);
}

// OBSOLETE, not used
- (void)updateImageAspectRatioConstraintFromImage:(UIImage *)image
{
  AssertTrueOrReturn(image);
  
  if (self.imageViewAspectRatioConstraint) {
    [self.imageView removeConstraint:self.imageViewAspectRatioConstraint];
  }
  CGFloat aspectRatio = image.size.height / image.size.width;
  AssertTrueOrReturn(aspectRatio != 0);
  
  NSLayoutConstraint *aspectConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.imageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:aspectRatio
                                                                      constant:0.f];
  [self.imageView addConstraint:aspectConstraint];
  self.imageViewAspectRatioConstraint = aspectConstraint;
}

@end
