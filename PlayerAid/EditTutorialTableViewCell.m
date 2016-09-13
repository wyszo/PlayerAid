//
//  PlayerAid
//

@import TWCommonLib;
#import "EditTutorialTableViewCell.h"

@interface EditTutorialTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *playIconImageView;
@end

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
    text = [tutorialStep.text tw_stringByRemovingHtmlTags];
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
    self.thumbnailImageView.image = [UIImage imageNamed:@"typebtn_edit"];
  } else if ([tutorialStep isImageStep]) {
    [tutorialStep placeImageInImageView:self.thumbnailImageView];
  } else if ([tutorialStep isVideoStep]) {
    self.thumbnailImageView.image = tutorialStep.thumbnailImage;
    self.playIconImageView.hidden = NO;
  }
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  self.thumbnailImageView.image = nil;
  self.playIconImageView.hidden = YES;
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
