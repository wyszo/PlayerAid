//
//  PlayerAid
//

#import "PublishingTutorialViewController.h"
#import "ServerDataUpdateController.h"
#import "AlertFactory.h"

static NSString *const kNibFileName = @"PublishingTutorialView";


@interface PublishingTutorialViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *progressBarImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarBackgroundWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarWidthConstraint;

@end


@implementation PublishingTutorialViewController

- (instancetype)init
{
  self = [super initWithNibName:kNibFileName bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initializeProgressBarImageView];
  self.progressBarWidthConstraint.constant = 0.0f;
  
  [self publishTutorial];
}

- (void)initializeProgressBarImageView
{
  CGFloat inset = 4.5f;
  self.progressBarImageView.image = [[UIImage imageNamed:@"ProgressBarBlue"] resizableImageWithCapInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
}

- (void)publishTutorial
{
  AssertTrueOrReturn(self.tutorial);
  
  defineWeakSelf();
  [ServerDataUpdateController saveTutorial:self.tutorial progressChanged:^(CGFloat progress) {
    AssertTrueOr(progress >= 0 && progress <= 1.0, ;);
    weakSelf.progressBarWidthConstraint.constant = progress * weakSelf.progressBarBackgroundWidthConstraint.constant;
    
    DISPATCH_ASYNC_ON_MAIN_THREAD(^{
      [weakSelf.view setNeedsLayout];
    });
  } completion:^(NSError *error) {
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      if (error) {
        [AlertFactory showOKAlertViewWithMessage:@"<DEBUG> Publishing tutorial network error!!!"];
      } else {
        [AlertFactory showOKAlertViewWithMessage:@"<DEBUG> Publishing success, tutorial in review!! :D"];
      }
      
      if (weakSelf.completionBlock) {
        weakSelf.completionBlock(error);
      }
    }];
  }];
}

@end
