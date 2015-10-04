//
//  PlayerAid
//

@import Foundation;

@interface TutorialCellHelper : NSObject

- (CGFloat)cellHeightForCurrentScreenWidthWithBottomGapVisible:(BOOL)bottomGapVisible;
- (CGFloat)bottomGapHeight;
- (UINib *)tutorialCellNib;

@end
