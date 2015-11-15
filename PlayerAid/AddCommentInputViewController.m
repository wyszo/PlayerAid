//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "AddCommentInputViewController.h"
#import "AuthenticatedServerCommunicationController.h"

static NSString *const kXibFileName = @"AddCommentInputView";

@interface AddCommentInputViewController ()
@property (strong, nonatomic, nonnull) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@end

@implementation AddCommentInputViewController

- (instancetype)initWithUser:(User *)user
{
  AssertTrueOrReturnNil(user);
  self = [super initWithNibName:kXibFileName bundle:nil];
  if (self) {
    _user = user;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.user placeAvatarInImageView:self.avatarImageView];
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
