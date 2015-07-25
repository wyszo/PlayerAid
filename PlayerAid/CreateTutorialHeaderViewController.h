//
//  PlayerAid
//

#import "Section.h"
#import "Tutorial.h"


@interface CreateTutorialHeaderViewController : UIViewController

@property (weak, nonatomic) UIViewController *imagePickerPresentingViewController;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic, readonly) Section *selectedSection;
@property (assign, nonatomic, readonly) BOOL hasAnyData;
@property (assign, nonatomic, readonly) BOOL hasAllDataRequiredToPublish;

- (BOOL)validateTutorialDataCompleteShowErrorAlerts;
- (void)updateWithTutorial:(Tutorial *)tutorial;

@end
