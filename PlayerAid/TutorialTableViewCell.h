//
//  PlayerAid
//

#import "Tutorial.h"


@interface TutorialTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^tutorialFavouritedBlock)(BOOL favourited, TutorialTableViewCell *tutorialCell);
@property (copy, nonatomic) void (^userAvatarSelectedBlock)(User *user);
@property (assign, nonatomic) BOOL showBottomGap;
@property (assign, nonatomic) BOOL canBeDeletedOnSwipe;

- (void)configureWithTutorial:(Tutorial *)tutorial;
- (void)updateLikeButtonState;

@end
