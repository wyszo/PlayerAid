//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import DateTools;
@import AFNetworking;
#import "TutorialCommentCell.h"
#import "User.h"
#import "UIImageView+AvatarStyling.h"
#import "ColorsHelper.h"

static const NSInteger kMaxFoldedCommentNumberOfLines = 5;
static CGFloat defaultMoreButtonHeightConstraintConstant;

@interface TutorialCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;
@property (assign, nonatomic) BOOL expanded;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonHeightConstraint;
@end

@implementation TutorialCommentCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.defaultBackgroundColor = self.contentView.backgroundColor;
  [self.avatarImageView makeCircular];
  [self tw_configureForFullWidthSeparators];
  self.timeAgoLabel.textColor = [ColorsHelper commentsTimeAgoLabelColor];
  [self setupCommentTextLabelMaxLineCount];
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  self.contentView.backgroundColor = self.defaultBackgroundColor;
  self.avatarImageView.image = nil;
  [self.avatarImageView cancelImageRequestOperation];
  self.moreButton.hidden = NO;
  self.expanded = NO;
  
  [self setupCommentTextLabelMaxLineCount];
  [self restoreMoreButtonHeightConstraint];
}

- (void)setupCommentTextLabelMaxLineCount
{
  self.commentLabel.numberOfLines = kMaxFoldedCommentNumberOfLines;
}

#pragma mark TWConfigurableFromDictionary

- (void)configureWithTutorialComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  User *commentAuthor = comment.madeBy;
  
  self.authorLabel.text = commentAuthor.name;
  self.commentLabel.text = comment.text;
  self.timeAgoLabel.text = [comment.createdOn shortTimeAgoSinceNow];
  
  [self updateMoreButtonVisibility];
  [commentAuthor placeAvatarInImageView:self.avatarImageView];
}

#pragma mark - public

- (BOOL)isExpanded
{
  return self.expanded || [self shouldHideMoreButton]; // lineCount equals either 0 or <= maxNrOfLines
}

- (void)expandCell
{
  BOOL bothBeforeAndAfterAnimationBlocksSet = (self.willChangeCellHeightBlock && self.didChangeCellHeightBlock);
  AssertTrueOrReturn(bothBeforeAndAfterAnimationBlocksSet && "either none of the blocks or both have to be set (willChange.. should call beginUpdates on tableView and didChange should call endUpdates");
  
  CallBlock(self.willChangeCellHeightBlock);
  self.commentLabel.numberOfLines = 0; // this will trigger animations if willChange/didChange blocks contain calls to beginUpdates and endUpdates on tableView
  [self hideMoreButton]; // cell extended, we don't need more button anymore
  self.expanded = YES;
  CallBlock(self.didChangeCellHeightBlock);
}

- (void)setSelected:(BOOL)selected
{
  UIColor *backgroundColor = self.defaultBackgroundColor;
  if (selected) {
    backgroundColor = [ColorsHelper editedCommentTableViewCellBackgroundColor];
  }
  self.contentView.backgroundColor = backgroundColor;
}

#pragma mark - private

- (void)updateMoreButtonVisibility
{
  BOOL shouldHideMoreButton = [self shouldHideMoreButton];
  if (shouldHideMoreButton) {
    [self shrinkMoreButtonHeight];
  }
  self.moreButton.hidden = shouldHideMoreButton;
}

- (BOOL)shouldHideMoreButton
{
  return ([self.commentLabel tw_lineCount] <= kMaxFoldedCommentNumberOfLines);
}

- (void)hideMoreButton
{
  self.moreButton.hidden = YES;
  [self shrinkMoreButtonHeight];
}

#pragma mark - Constraints manipulation

- (void)shrinkMoreButtonHeight
{
  if (defaultMoreButtonHeightConstraintConstant == 0) {
    defaultMoreButtonHeightConstraintConstant = self.moreButtonHeightConstraint.constant;
  }
  self.moreButtonHeightConstraint.constant = 0;
}

- (void)restoreMoreButtonHeightConstraint
{
  AssertTrueOrReturn(defaultMoreButtonHeightConstraintConstant != 0.0);
  self.moreButtonHeightConstraint.constant = defaultMoreButtonHeightConstraintConstant;
}

#pragma mark - IBActions

- (IBAction)moreButtonPressed:(id)sender {
  [self expandCell];
}

@end
