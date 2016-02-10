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
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet CommentBottomBarView *commentBottomBar;
@property (strong, nonatomic) TutorialComment *comment;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;
@property (assign, nonatomic) BOOL expanded;
@property (nonatomic, readwrite) BOOL isCommentReplyCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeAgoBarToMoreButtonDistanceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonHeightConstraint;
@end

@implementation TutorialCommentCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.defaultBackgroundColor = self.contentView.backgroundColor;
  [self.avatarImageView makeCircularSetAspectFit];
  [self tw_configureForFullWidthSeparators];

  self.commentLabel.textColor = [ColorsHelper commentLabelTextColor];
  [self setupCommentTextLabelMaxLineCount];
  [self saveDefaultTimeAgoToMoreButtonConstraintValue];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  
  self.contentView.backgroundColor = self.defaultBackgroundColor;
  [self setSelected:NO];
  [self setHighlighted:NO];
  self.avatarImageView.image = nil;
  [self.avatarImageView cancelImageRequestOperation];
  self.moreButton.hidden = NO;
  self.expanded = NO;
  self.replyButtonHidden = NO;
  self.isCommentReplyCell = NO;
  
  [self setupCommentTextLabelMaxLineCount];
  [self restoreMoreButtonHeightConstraint];
  [self restoreDefaultTimeAgoBarToMoreButtonConstraint];
}

- (void)setupCommentTextLabelMaxLineCount {
  self.commentLabel.numberOfLines = kMaxFoldedCommentNumberOfLines;
}

#pragma mark TWConfigurableFromDictionary

- (void)configureWithTutorialComment:(TutorialComment *)comment {
  AssertTrueOrReturn(comment);
  _comment = comment;

  self.isCommentReplyCell = (comment.isReplyTo != nil);
  User *commentAuthor = comment.madeBy;
  
  self.authorLabel.text = commentAuthor.name;
  self.commentLabel.text = comment.text;
  [self configureBottomBarWithTutorialComment:comment];
  
  [self updateCellStyling];
  [self updateMoreButtonVisibility];
  [commentAuthor placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSize32];

  [self updateElementsSpacingConstraintsInvokingHeightChangeCallback:YES];
}

- (void)configureBottomBarWithTutorialComment:(TutorialComment *)comment {
  AssertTrueOrReturn(comment);
  
  AssertTrueOr(self.commentBottomBar,);
  self.commentBottomBar.timeAgoLabel.text = [comment.createdOn shortTimeAgoSinceNow];
  [self.commentBottomBar setNumberOfLikes:[self likesCountForComment:comment]];
  [self updateCommentsBarLikeButtonStateForComment:comment];

  defineWeakSelf();
  self.commentBottomBar.likeButtonPressed = ^() {
    if (weakSelf.comment.upvotedByUserValue) {
      CallBlock(weakSelf.unlikeButtonPressedBlock, weakSelf.comment);
    } else {
      CallBlock(weakSelf.likeButtonPressedBlock, weakSelf.comment);
    }
  };
}

- (void)updateCommentsBarLikeButtonStateForComment:(TutorialComment *)comment {
  AssertTrueOrReturn(comment);

  BOOL active = !comment.upvotedByUserValue;
  [self.commentBottomBar setLikeButtonActive:active];
}

- (NSUInteger)likesCountForComment:(TutorialComment *)comment {
  AssertTrueOr(comment, return 0;);

  NSUInteger likesCount = self.comment.likedBy.count;
  if (likesCount == 0) {
    likesCount = self.comment.likesCountValue; // fallback value until we have linkedBy relationship populated with data
  }
  return likesCount;
}

#pragma mark - public

- (BOOL)isExpanded {
  return self.expanded || [self shouldHideMoreButton]; // lineCount equals either 0 or <= maxNrOfLines
}

- (void)expandCell {
  BOOL bothBeforeAndAfterAnimationBlocksSet = (self.willChangeCellHeightBlock && self.didChangeCellHeightBlock);
  AssertTrueOrReturn(bothBeforeAndAfterAnimationBlocksSet && "either none of the blocks or both have to be set (willChange.. should call beginUpdates on tableView and didChange should call endUpdates");
  
  CallBlock(self.willChangeCellHeightBlock);
  self.commentLabel.numberOfLines = 0; // this will trigger animations if willChange/didChange blocks contain calls to beginUpdates and endUpdates on tableView
  [self hideMoreButton]; // cell extended, we don't need more button anymore
  self.expanded = YES;
  [self updateElementsSpacingConstraintsInvokingHeightChangeCallback:YES];
}

- (void)setHighlighted:(BOOL)highlighted {
  UIColor *backgroundColor = self.defaultBackgroundColor;
  if (highlighted) {
    backgroundColor = [ColorsHelper editedCommentTableViewCellBackgroundColor];
  }
  self.contentView.backgroundColor = backgroundColor;
}

#pragma mark - Accessors

- (void)setReplyButtonHidden:(BOOL)replyButtonHidden {
  _replyButtonHidden = replyButtonHidden;
  self.replyButton.hidden = replyButtonHidden;
}

#pragma mark - private

- (void)updateMoreButtonVisibility {
  BOOL shouldHideMoreButton = [self shouldHideMoreButton];
  if (shouldHideMoreButton) {
    [self shrinkMoreButtonHeight];
  }
  self.moreButton.hidden = shouldHideMoreButton;
}

- (BOOL)shouldHideMoreButton {
  return ([self.commentLabel tw_lineCount] <= kMaxFoldedCommentNumberOfLines);
}

- (void)hideMoreButton {
  self.moreButton.hidden = YES;
  [self shrinkMoreButtonHeight];
}

- (void)updateCellStyling {
  CGFloat avatarEdgeLength = 32.0;
  
  if (self.isCommentReplyCell) {
    avatarEdgeLength = 22.0;
  }
  self.avatarImageViewWidthConstraint.constant = avatarEdgeLength;
  [self layoutIfNeeded]; // required to recalculate frame before updating corner radius
  
  [self.avatarImageView makeCircularSetAspectFit];
}

#pragma mark - Constraints manipulation - elements spacing

- (void)updateElementsSpacingConstraintsInvokingHeightChangeCallback:(BOOL)heightChangeCallback {
  if ([self isExpanded]) {
    [self shrinkTimeAgoToMoreButtonDistance]; // when cell is expanded the distance is smaller (because '...' button is not there anymore)
  }

  if (heightChangeCallback) {
    CallBlock(self.didChangeCellHeightBlock);
  }
}

- (void)saveDefaultTimeAgoToMoreButtonConstraintValue {
  if (expandedTimeAgoBarToMoreButtonDistanceConstraintConstant == 0) {
    CGFloat constant = self.timeAgoBarToMoreButtonDistanceConstraint.constant;
    AssertTrueOrReturn(constant != 0);
    expandedTimeAgoBarToMoreButtonDistanceConstraintConstant = constant;
  }
}

- (void)shrinkTimeAgoToMoreButtonDistance {
  self.timeAgoBarToMoreButtonDistanceConstraint.constant = kFoldedTimeAgoBarToMoreButtonDistanceConstraint;
}

#pragma mark - Constraints manipulation - '...' button

- (void)shrinkMoreButtonHeight {
  if (defaultMoreButtonHeightConstraintConstant == 0) {
    defaultMoreButtonHeightConstraintConstant = self.moreButtonHeightConstraint.constant;
  }
  self.moreButtonHeightConstraint.constant = 0;
}

- (void)restoreMoreButtonHeightConstraint {
  AssertTrueOrReturn(defaultMoreButtonHeightConstraintConstant != 0.0);
  self.moreButtonHeightConstraint.constant = defaultMoreButtonHeightConstraintConstant;
}

- (void)restoreDefaultTimeAgoBarToMoreButtonConstraint {
  AssertTrueOrReturn(expandedTimeAgoBarToMoreButtonDistanceConstraintConstant != 0.0);
  self.timeAgoBarToMoreButtonDistanceConstraint.constant = expandedTimeAgoBarToMoreButtonDistanceConstraintConstant;
}

#pragma mark - IBActions

- (IBAction)moreButtonPressed:(id)sender {
  [self expandCell];
}

- (IBAction)avatarButtonPressed:(id)sender {
  CallBlock(self.didPressUserAvatarOrName, self.comment);
}

- (IBAction)usernamePressed:(id)sender {
  CallBlock(self.didPressUserAvatarOrName, self.comment);
}

- (IBAction)replyButtonPressed:(id)sender {
  CallBlock(self.didPressReplyButtonBlock, self.comment);
}

@end
