//
//  PlayerAid
//

#import <UIKit/UIKit.h>
#import "Section.h"


@protocol SaveTutorialDelegate;


@interface CreateTutorialHeaderViewController : UIViewController

@property (weak, nonatomic) UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> *imagePickerControllerDelegate;
@property (weak, nonatomic) id<SaveTutorialDelegate> saveDelegate;

@end


@protocol SaveTutorialDelegate
@required
- (void)saveTutorialTitled:(NSString *)title section:(Section *)section;
@end