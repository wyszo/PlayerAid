//
//  PlayerAid
//

#import "Section.h"


@protocol SaveTutorialDelegate;


@interface CreateTutorialHeaderViewController : UIViewController

@property (weak, nonatomic) UIViewController *imagePickerPresentingViewController;
@property (weak, nonatomic) id<SaveTutorialDelegate> saveDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end


@protocol SaveTutorialDelegate
@required
- (void)saveTutorialTitled:(NSString *)title section:(Section *)section;
@end
