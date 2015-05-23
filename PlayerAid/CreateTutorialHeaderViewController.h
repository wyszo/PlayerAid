//
//  PlayerAid
//

#import "Section.h"


@interface CreateTutorialHeaderViewController : UIViewController

@property (weak, nonatomic) UIViewController *imagePickerPresentingViewController;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) Section *selectedSection;

- (CGFloat)headerViewHeightForWidth:(CGFloat)width;

- (BOOL)validateTutorialDataCompleteShowErrorAlerts;

@end
