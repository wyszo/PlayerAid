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

static NSString *const kXibFileName = @"MakeCommentInputView";

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
  [self styleInputTextView];
  [self.avatarImageView makeCircularSetAspectFit];
  [self.user placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSizeSmall];
  [self.view tw_addTopBorderWithWidth:0.5f color:[ColorsHelper makeEditCommentInputViewTopBorderColor]];
}

- (void)styleInputTextView
{
  self.inputTextView.placeholder = @"add a comment..";
  self.inputTextView.placeholderColor = [ColorsHelper makeCommentInputTextViewPlaceholderColor];
  self.inputTextView.placeholderLabel.alpha = 0.8f;
  
  self.inputTextView.textColor = [ColorsHelper makeCommentInputTextViewTextColor];
}

#pragma mark - Dismissing keyboard

- (void)didMoveToParentViewController:(UIViewController *)parent
{
  [super didMoveToParentViewController:parent];
  if (parent == nil) {
    [self.inputTextView resignFirstResponder];
  }
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
