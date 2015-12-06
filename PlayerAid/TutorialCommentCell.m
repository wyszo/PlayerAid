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
#import "PlayerAid-Swift.h"

static const NSInteger kMaxFoldedCommentNumberOfLines = 5;
static const CGFloat kFoldedTimeAgoBarToMoreButtonDistanceConstraint = -6.0f;

static CGFloat defaultMoreButtonHeightConstraintConstant;
static CGFloat expandedTimeAgoBarToMoreButtonDistanceConstraintConstant;

@class CommentBottomBarView;

/**
 Technical debt: Constraint animations should be provided by a separate class! The view controller itself should not know about precise constraint values, it should only know if cell is expanded or folded.
 */
@interface TutorialCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet CommentBottomBarView *commentBottomBar;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;
@property (assign, nonatomic) BOOL expanded;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeAgoBarToMoreButtonDistanceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonHeightConstraint;
@end

@implementation TutorialCommentCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.defaultBackgroundColor = self.contentView.backgroundColor;
  [self.avatarImageView makeCircularSetAspectFit];
  [self tw_configureForFullWidthSeparators];
  self.commentLabel.textColor = [ColorsHelper commentLabelTextColor];
  [self setupCommentTextLabelMaxLineCount];
  [self saveDefaultTimeAgoToMoreButtonConstraintValue];
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
  [self restoreDefaultTimeAgoBarToMoreButtonConstraint];
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
  [self configureBottomBarWithTutorialComment:comment];
  
  [self updateMoreButtonVisibility];
  [commentAuthor placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSize32];
  [self updateElementsSpacingConstraints];
}

- (void)configureBottomBarWithTutorialComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  
  AssertTrueOr(self.commentBottomBar,);
  self.commentBottomBar.timeAgoLabel.text = [comment.createdOn shortTimeAgoSinceNow];
  [self.commentBottomBar setNumberOfLikes:comment.likedBy.count]; // perhaps this value should dynamically update?
  
  self.commentBottomBar.likeButtonPressed = ^() {
    // TODO: send like comment network request!
  };
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
  [self updateElementsSpacingConstraints];
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

#pragma mark - Constraints manipulation - elements spacing

- (void)updateElementsSpacingConstraints
{
  if ([self isExpanded]) {
    [self shrinkTimeAgoToMoreButtonDistance]; // when cell is expanded the distance is smaller (because '...' button is not there anymore)
  }
}

- (void)saveDefaultTimeAgoToMoreButtonConstraintValue
{
  if (expandedTimeAgoBarToMoreButtonDistanceConstraintConstant == 0) {
    CGFloat constant = self.timeAgoBarToMoreButtonDistanceConstraint.constant;
    AssertTrueOrReturn(constant != 0);
    expandedTimeAgoBarToMoreButtonDistanceConstraintConstant = constant;
  }
}

- (void)shrinkTimeAgoToMoreButtonDistance
{
  self.timeAgoBarToMoreButtonDistanceConstraint.constant = kFoldedTimeAgoBarToMoreButtonDistanceConstraint;
}

#pragma mark - Constraints manipulation - '...' button

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

- (void)restoreDefaultTimeAgoBarToMoreButtonConstraint
{
  AssertTrueOrReturn(expandedTimeAgoBarToMoreButtonDistanceConstraintConstant != 0.0);
  self.timeAgoBarToMoreButtonDistanceConstraint.constant = expandedTimeAgoBarToMoreButtonDistanceConstraintConstant;
}

#pragma mark - IBActions

- (IBAction)moreButtonPressed:(id)sender {
  [self expandCell];
}

- (IBAction)replyButtonPressed:(id)sender {
}

@end
