//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import "Tutorial.h"
#import <TWCommonLib/TWCommonTypes.h>

@interface TutorialDetailsHelper : NSObject

- (void)performTutorialDetailsSegueFromViewController:(UIViewController *)viewController;

// Call this inside prepareForSegue
- (void)prepareForTutorialDetailsSegue:(UIStoryboardSegue *)segue pushingTutorial:(Tutorial *)tutorial;

- (UIBarButtonItem *)reportTutorialBarButtonItem:(Tutorial *)tutorial;

@end
