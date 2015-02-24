//
//  PlayerAid
//

#import "Tutorial.h"


@interface TutorialTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^tutorialFavouritedBlock)(BOOL favourited);

- (void)configureWithTutorial:(Tutorial *)tutorial;
- (void)showBottomGap:(BOOL)showGap;

+ (CGFloat)cellHeightForCellWithBottomGap:(BOOL)includeBottomGap;

@end
