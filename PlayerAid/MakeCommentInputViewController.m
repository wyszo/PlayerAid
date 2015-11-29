//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import UITextView_Placeholder;
#import "MakeCommentInputViewController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"

static NSString *const kXibFileName = @"AddCommentInputView";

@interface MakeCommentInputViewController () <UITextViewDelegate>
@property (strong, nonatomic, nonnull) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
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
  
  self.inputTextView.delegate = self;
  [self updatePostButtonHighlight];
}

- (void)styleSubviews
{
  self.inputTextView.placeholder = @"add a comment..";
  self.inputTextView.placeholderColor = [UIColor colorWithWhite:(152.0/255.0) alpha:1.0];
  
  [self.avatarImageView makeCircular];
  [self.user placeAvatarInImageView:self.avatarImageView];
  [self.view tw_addTopBorderWithWidth:1.0f color:[ColorsHelper makeEditCommentInputViewTopBorderColor]];
}

#pragma mark - IBOutlet

- (IBAction)postButtonPressed:(id)sender
{
  if (!self.postButtonActive) {
    return;
  }
  
  NSString *commentText = self.trimmedCommentText;
  AssertTrueOrReturn(commentText.length);
  
  CallBlock(self.postButtonPressedBlock, commentText, ^(BOOL success){
    if (success) {
      [self clearInputTextView];
      [self.inputTextView resignFirstResponder]; // hide the keyboard
    }
  });
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView * _Nonnull)textView
{
  [self updatePostButtonHighlight];
}

#pragma mark - Private

- (void)clearInputTextView
{
  self.inputTextView.text = @"";
}

- (NSString *)trimmedCommentText
{
  return [self.inputTextView.text tw_stringByTrimmingWhitespaceAndNewline];
}

- (void)updatePostButtonHighlight
{
  UIColor *buttonBackgroundColor = [ColorsHelper makeCommentPostButtonInactiveBackgroundColor];
  
  if ([self postButtonActive]) {
    buttonBackgroundColor = [ColorsHelper makeCommentPostButtonActiveBackgroundColor];
  }
  self.postButton.backgroundColor = buttonBackgroundColor;
}

- (BOOL)postButtonActive
{
  return (self.trimmedCommentText.length > 0);
}

@end
