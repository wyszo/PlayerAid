//
//  PlayerAid
//

#import "PublishingTutorialViewController.h"
#import "ServerDataUpdateController.h"
#import "AlertFactory.h"
#import "TWInterfaceOrientationViewControllerDecorator.h"

static NSString *const kNibFileName = @"PublishingTutorialView";


@interface PublishingTutorialViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *progressBarImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarBackgroundWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarWidthConstraint;

@end


@implementation PublishingTutorialViewController

#pragma mark - Initialization

+ (void)initialize
{
  [[TWInterfaceOrientationViewControllerDecorator new] addInterfaceOrientationMethodsToClass:self.class shouldAutorotate:NO];
}

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
  
  [self publishTutorial];
}

- (void)initializeProgressBarImageView
{
  CGFloat inset = 4.5f;
  self.progressBarImageView.image = [[UIImage imageNamed:@"ProgressBarBlue"] resizableImageWithCapInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
}

#pragma mark - Publishing tutorial logic

- (void)publishTutorial
{
  [self resetProgressBar];
  AssertTrueOrReturn(self.tutorial);
  
  defineWeakSelf();
  [ServerDataUpdateController saveTutorial:self.tutorial progressChanged:^(CGFloat progress) {
    AssertTrueOr(progress >= 0 && progress <= 1.0, ;);
    weakSelf.progressBarWidthConstraint.constant = progress * weakSelf.progressBarBackgroundWidthConstraint.constant;
    
    DISPATCH_ASYNC_ON_MAIN_THREAD(^{
      [weakSelf.view setNeedsLayout];
    });
  } completion:^(NSError *error) {
    DISPATCH_ASYNC_ON_MAIN_THREAD(^{
      if (!error) {
        [AlertFactory showTutorialInReviewInfoAlertView];
        [weakSelf dismissViewControllerInvokingCompletionBlockWithError:error saveAsDraft:NO];
      }
      else {
        [weakSelf showPublisihngTutorialFailedAlertViewWithError:error];
      }
    });
  }];
}

#pragma mark - Auxiliary methods

- (void)resetProgressBar
{
  self.progressBarWidthConstraint.constant = 0.0f;
  [self.view setNeedsLayout];
}

- (void)showPublisihngTutorialFailedAlertViewWithError:(NSError *)error
{
  AssertTrueOrReturn(error);
  
  defineWeakSelf();
  [AlertFactory showPublishingTutorialFailedAlertViewWithSaveAction:^{
    [self dismissViewControllerInvokingCompletionBlockWithError:error saveAsDraft:YES];
  } retryAction:^{
    DISPATCH_ASYNC(QueuePriorityDefault, ^{
      [weakSelf publishTutorial];
    });
  }];
}

#pragma mark - Dismiss

- (void)dismissViewControllerInvokingCompletionBlockWithError:(NSError *)error saveAsDraft:(BOOL)saveAsDraft
{
  [self dismissViewControllerAnimated:YES completion:^{
    if (self.completionBlock) {
      self.completionBlock(saveAsDraft, error);
    }
  }];
}

@end
