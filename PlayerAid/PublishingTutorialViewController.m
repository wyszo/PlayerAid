//
//  PlayerAid
//

#import "PublishingTutorialViewController.h"
#import "ServerDataUpdateController.h"

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
      if (weakSelf.completionBlock) {
        weakSelf.completionBlock();
      }
    }];
  }];
}

@end
