//
//  PlayerAid
//

#import <UIKit/UIKit.h>
#import "Tutorial.h"


@interface TutorialTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^tutorialFavouritedBlock)(BOOL favourited);

- (void)configureWithTutorial:(Tutorial *)tutorial;

@end
