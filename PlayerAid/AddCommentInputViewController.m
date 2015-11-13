//
//  PlayerAid
//

@import TWCommonLib;
#import "AddCommentInputViewController.h"
#import "AuthenticatedServerCommunicationController.h"

static NSString *const kXibFileName = @"AddCommentInputView";

@interface AddCommentInputViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@end

@implementation AddCommentInputViewController

- (instancetype)init
{
  self = [super initWithNibName:kXibFileName bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

#pragma mark - IBOutlet

- (IBAction)postButtonPressed:(id)sender
{
  // TODO: make a network request with a new comment
  NSString *commentText = @"comment text"; // TODO
  Tutorial *tutorial = nil; // TODO
  
  [[AuthenticatedServerCommunicationController sharedInstance] addAComment:commentText toTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    // TODO: implement this
  }];
}

@end
