//
//  PlayerAid
//

#import "PublishingTutorialViewController.h"
#import "ServerDataUpdateController.h"
#import "AlertFactory.h"

static NSString *const kNibFileName = @"PublishingTutorialView";


@interface PublishingTutorialViewController ()
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
  [self publishTutorial];
}

- (void)publishTutorial
{
  AssertTrueOrReturn(self.tutorial);
  
  defineWeakSelf();
  [ServerDataUpdateController saveTutorial:self.tutorial completion:^(NSError *error) {
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      if (error) {
        [AlertFactory showOKAlertViewWithMessage:@"<DEBUG> Publishing tutorial network error!!!"];
      }
      
      if (weakSelf.completionBlock) {
        weakSelf.completionBlock(error);
      }
    }];
  }];
}

@end
