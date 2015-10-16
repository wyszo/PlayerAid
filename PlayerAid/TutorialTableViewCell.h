//
//  PlayerAid
//

@import UIKit;
#import "Tutorial.h"

@interface TutorialTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^tutorialFavouritedBlock)(BOOL favourited, TutorialTableViewCell *tutorialCell);
@property (copy, nonatomic) void (^userAvatarSelectedBlock)(User *user);
@property (assign, nonatomic) BOOL showBottomGap;
@property (assign, nonatomic) BOOL canBeDeletedOnSwipe;

- (void)configureWithTutorial:(Tutorial *)tutorial;
- (void)updateLikeButtonState;

/**
 @param   showGradientOverlay   Determines whether to show dark bottom gradient overlay or default plain full-screen overlay
 */
- (void)showGradientOverlay:(BOOL)showGradientOverlay;

@end
