//
//  PlayerAid
//

#import "Tutorial.h"


@interface TutorialDetailsHelper : NSObject

- (void)performTutorialDetailsSegueFromViewController:(UIViewController *)viewController;

// Call this inside prepareForSegue
- (void)prepareForTutorialDetailsSegue:(UIStoryboardSegue *)segue pushingTutorial:(Tutorial *)tutorial deallocBlock:(VoidBlock)deallocBlock;

@end