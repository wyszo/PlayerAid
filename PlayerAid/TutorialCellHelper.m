//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "TutorialCellHelper.h"

static const CGFloat kIPhone5ScreenWidth = 320.0f;
static const CGFloat kIPhone5CellHeight = 320.0f;

static const CGFloat kTutorialCellWithGapAspectRatio = kIPhone5ScreenWidth/kIPhone5CellHeight;
static const CGFloat kTutorialCellBottomGapHeight = 18.0f;
static const CGFloat kTutorialCellNoGapAspectRatio = kIPhone5ScreenWidth/(kIPhone5CellHeight - kTutorialCellBottomGapHeight);

static NSString *const kTutorialCellNibName = @"TutorialTableViewCell";


@implementation TutorialCellHelper

- (CGFloat)cellHeightForCurrentScreenWidthWithBottomGapVisible:(BOOL)bottomGapVisible
{
  CGFloat aspectRatio = (bottomGapVisible ? kTutorialCellWithGapAspectRatio : kTutorialCellNoGapAspectRatio);
  AssertTrueOr(aspectRatio != 0, return 0;);
  CGFloat cellHeight = ([UIScreen tw_width] / aspectRatio);
  AssertTrueOr(cellHeight != 0,);
  return cellHeight;
}

- (CGFloat)bottomGapHeight
{
  return kTutorialCellBottomGapHeight;
}

#pragma mark - Nib

- (UINib *)tutorialCellNib
{
  return [UINib nibWithNibName:kTutorialCellNibName bundle:[NSBundle mainBundle]];
}

@end
