//
//  PlayerAid
//

#import "PublishingTutorialViewController.h"
#import "UIView+XibLoading.h"


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
  
  // TODO: make a network requests to create a tutorial!
  // TODO: make a network requests to submit tutorial image step(s)
  // TODO: make a network requests to submit tutorial video step(s)
  // TODO: make a network requests to submit tutorial text step(s)
  // TODO: make a network requests to upload tutorial image
  // TODO: make a network reqeust to submit tutorial to review
  // note all the above have to be atomic operations
  
  DISPATCH_AFTER(3.0f, ^{
    [self dismissViewControllerAnimated:YES completion:^{
      if (self.completionBlock) {
        self.completionBlock();
      }
    }];
  });
}

@end
