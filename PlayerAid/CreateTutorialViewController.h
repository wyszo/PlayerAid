//
//  PlayerAid
//

#import "Tutorial.h"


@interface CreateTutorialViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// optional, can only be set before the view appeared
@property (nonatomic, weak) Tutorial *tutorialToDisplay;

/**
 Determines whether viewController is meant to create a new tutorial from scratch or editing existing draft.
 Alerts presented on dismissing viewController depend on this value. 
 Defaults to NO (meaning it's a brand new tutorial).
 */
@property (nonatomic, assign) BOOL isEditingDraft;

@end
