//
//  PlayerAid
//

#import "Section.h"


@interface CreateTutorialHeaderViewController : UIViewController

@property (weak, nonatomic) UIViewController *imagePickerPresentingViewController;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic, readonly) Section *selectedSection;
@property (assign, nonatomic, readonly) BOOL hasAnyData;

- (BOOL)validateTutorialDataCompleteShowErrorAlerts;

@end
