//
//  PlayerAid
//

#import "EditTutorialTableViewCell.h"


@implementation EditTutorialTableViewCell

#pragma mark - Configuring cell

- (void)configureWithTutorialStep:(TutorialStep *)tutorialStep
{
  [self configureTitleLabelWithTutorialStep:tutorialStep];
  [self configureThumbnailWithTutorialStep:tutorialStep];
}

- (void)configureTitleLabelWithTutorialStep:(TutorialStep *)tutorialStep
{
  NSString *text;
  
  if ([tutorialStep isTextStep]) {
    text = tutorialStep.text;
  } else if ([tutorialStep isImageStep]) {
    text = @"Photo";
  } else if ([tutorialStep isVideoStep]) {
    text = @"Video";
  }
  self.titleLabel.text = text;
}

- (void)configureThumbnailWithTutorialStep:(TutorialStep *)tutorialStep
{
  if ([tutorialStep isTextStep]) {
    // TODO: apply default text thumbnail!
  } else if ([tutorialStep isImageStep]) {
    self.thumbnailImageView.image = tutorialStep.image;
  } else if ([tutorialStep isVideoStep]) {
    self.thumbnailImageView.image = tutorialStep.thumbnailImage;
  }
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  self.thumbnailImageView.image = nil;
  self.titleLabel.text = @"";
}

#pragma mark - Properties

- (UITableViewCellEditingStyle)editingStyle
{
  return UITableViewCellEditingStyleNone;
}

- (BOOL)shouldIndentWhileEditing
{
  return NO;
}

#pragma mark - IBActions

- (IBAction)deleteAction:(id)sender
{
  if (self.deleteCellBlock) {
    self.deleteCellBlock();
  }
}

@end
