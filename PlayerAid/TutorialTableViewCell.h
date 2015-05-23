//
//  PlayerAid
//

#import "Tutorial.h"


@interface TutorialTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^tutorialFavouritedBlock)(BOOL favourited);
@property (assign, nonatomic) BOOL showBottomGap;
@property (assign, nonatomic) BOOL canBeDeletedOnSwipe;

- (void)configureWithTutorial:(Tutorial *)tutorial;

+ (CGFloat)cellHeightForCellWithBottomGap:(BOOL)includeBottomGap;

@end
