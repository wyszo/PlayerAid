//
//  PlayerAid
//

#import "Tutorial.h"


@interface CreateTutorialViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// optional, can only be set before the view appeared
@property (nonatomic, weak) Tutorial *tutorialToDisplay;

@end
