//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import BlocksKit;
@import UITextView_Placeholder;
#import "MakeCommentInputViewController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"
#import "LimitInputTextViewLineCountBehaviour.h"

static const NSUInteger kMaxInputTextViewCharactersCount = 5000;

static NSString *const kXibFileName = @"MakeCommentInputView";
static NSString *const kSendingACommentKey = @"SendingComment";

@interface MakeCommentInputViewController () <UITextViewDelegate>
@property (strong, nonatomic, nonnull) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) LimitInputTextViewLineCountBehaviour *limitInputTextViewLineCountBehaviour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextViewTopMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextViewBottomMarginConstraint;
@end

@implementation MakeCommentInputViewController

#pragma mark - Init

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
  
  self.limitInputTextViewLineCountBehaviour = [[LimitInputTextViewLineCountBehaviour alloc] initWithInputTextView:self.inputTextView];
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
  self.inputTextView.scrollEnabled = NO;
  
  self.inputTextView.textColor = [ColorsHelper makeCommentInputTextViewTextColor];
}

#pragma mark - Public

- (BOOL)isInputTextViewFirstResponder
{
  return self.inputTextView.isFirstResponder;
}

- (void)hideKeyboard
{
  [self.inputTextView resignFirstResponder];
}

#pragma mark - Dismissing keyboard

- (void)willMoveToParentViewController:(UIViewController *)parent
{
  [super willMoveToParentViewController:parent];
  if (parent == nil) {
    // dismiss keyboard when dismissing TutorialDetails view (if it's open)
    [self.inputTextView resignFirstResponder];
  }
}

#pragma mark - IBOutlet

- (IBAction)postButtonPressed:(id)sender
{
  if (!self.postButtonActive) {
    return;
  }
  
  if (self.currentlySendingAComment) {
    // Technical debt: blocking multiple comment requests should be done on a network queue level, not in UI
    return; // awaiting server response from a previous request
  }
  [self setCurrentlySendingAComment:YES];
  
  NSString *commentText = self.trimmedCommentText;
  AssertTrueOrReturn(commentText.length);
  
  CallBlock(self.postButtonPressedBlock, commentText, ^(BOOL success){
    if (success) {
      // safe tu use self (instead of weakSelf), since the block is not retained by the class instance and executed instantly
      [self clearInputTextView];
      
      [self.inputTextView resignFirstResponder]; // hide the keyboard
      [self updateTextViewSizeAndAdjustWholeViewSize]; // shrink to one line
    }
    [self setCurrentlySendingAComment:NO];
  });
}

- (BOOL)currentlySendingAComment
{
  NSNumber *sendingAComment = [self bk_associatedValueForKey:(__bridge const void *)kSendingACommentKey];
  return [sendingAComment boolValue];
}

- (void)setCurrentlySendingAComment:(BOOL)sending
{
  [self bk_associateValue:@(sending) withKey:(__bridge const void *)kSendingACommentKey];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView * _Nonnull)textView
{
  AssertTrueOrReturn(textView == self.inputTextView);
  [self updateTextViewSizeAndAdjustWholeViewSize];
  // TODO: update tableView size so that comments at the bottom are always visible
  [self updatePostButtonHighlight];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)textToReplaceRange replacementText:(NSString *)replacementText
{
  return (textView.text.length + (replacementText.length - textToReplaceRange.length) <= kMaxInputTextViewCharactersCount);
}

#pragma mark - InputTextView sizing

- (void)updateTextViewSizeAndAdjustWholeViewSize
{
  [self.limitInputTextViewLineCountBehaviour updateTextViewSizeAndScrollEnabled];
  [self adjustWholeViewSizeToTextViewSize];
}

- (void)adjustWholeViewSizeToTextViewSize
{
  CGFloat viewBottom = self.view.tw_bottom;
  
  CGFloat computedViewHeight = ([self.limitInputTextViewLineCountBehaviour constrainedComputedTextViewHeight] + [self topBottomInputViewMarginConstraints]);
  self.view.tw_height = computedViewHeight;
  self.view.tw_bottom = viewBottom;
}

- (CGFloat)topBottomInputViewMarginConstraints
{
  AssertTrueOr(self.inputTextViewTopMarginConstraint,);
  AssertTrueOr(self.inputTextViewBottomMarginConstraint,);
  return (self.inputTextViewTopMarginConstraint.constant + self.inputTextViewBottomMarginConstraint.constant);
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
