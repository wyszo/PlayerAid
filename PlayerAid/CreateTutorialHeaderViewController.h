//
//  PlayerAid
//

#import "Section.h"
#import "Tutorial.h"
#import "TWCommonTypes.h"


@interface CreateTutorialHeaderViewController : UIViewController

@property (weak, nonatomic) UIViewController *imagePickerPresentingViewController;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic, readonly) Section *selectedSection;
@property (assign, nonatomic, readonly) BOOL hasAnyData;
@property (assign, nonatomic, readonly) BOOL hasAllDataRequiredToPublish;
@property (copy, nonatomic) VoidBlock valueDidChangeBlock;

- (BOOL)validateTutorialDataCompleteShowErrorAlerts;
- (void)updateWithTutorial:(Tutorial *)tutorial;

@end
