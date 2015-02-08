//
//  PlayerAid
//

#import "TutorialCellHelper.h"

static NSString *const kTutorialCellNibName = @"TutorialTableViewCell";


@implementation TutorialCellHelper

+ (CGFloat)cellHeightFromNib
{
  static UITableViewCell *sampleCell;
  if (!sampleCell) {
    sampleCell = [[[self nibForTutorialCell] instantiateWithOwner:nil options:nil] lastObject];
  }
  return sampleCell.frame.size.height;
}

+ (UINib *)nibForTutorialCell
{
  return [UINib nibWithNibName:kTutorialCellNibName bundle:[NSBundle bundleForClass:[self class]]];
}

@end
