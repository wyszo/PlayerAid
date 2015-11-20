//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import UITextView_Placeholder;
#import "MakeCommentInputViewController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "UIImageView+AvatarStyling.h"

static NSString *const kXibFileName = @"AddCommentInputView";

@interface MakeCommentInputViewController ()
@property (strong, nonatomic, nonnull) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@end

@implementation MakeCommentInputViewController

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
  [self styleSubviews];
}

- (void)styleSubviews
{
  self.inputTextView.placeholder = @"add a comment..";
  self.inputTextView.placeholderColor = [UIColor colorWithWhite:(152.0/255.0) alpha:1.0];
  
  [self.avatarImageView makeCircular];
  [self.user placeAvatarInImageView:self.avatarImageView];
  [self.view tw_addTopBorderWithWidth:1.0f color:[UIColor colorWithWhite:0 alpha:0.2f]];
}

#pragma mark - IBOutlet

- (IBAction)postButtonPressed:(id)sender
{
  NSString *commentText = self.inputTextView.text;
  AssertTrueOrReturn(commentText.length);
  
  CallBlock(self.postButtonPressedBlock, commentText, ^(BOOL success){
    if (success) {
      [self clearInputTextView];
      [self.inputTextView resignFirstResponder]; // hide the keyboard
    }
  });
}

#pragma mark - 

- (void)clearInputTextView
{
  self.inputTextView.text = @"";
}

@end
