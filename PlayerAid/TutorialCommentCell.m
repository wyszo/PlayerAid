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
#import "CommentRepliesCellConfigurator.h"
#import "PlayerAid-Swift.h"

static const NSInteger kMaxFoldedCommentNumberOfLines = 5;
static const CGFloat kFoldedTimeAgoBarToMoreButtonDistanceConstraint = -6.0f;
static const NSInteger kInlineRepliesFetchLimit = 7;

static CGFloat defaultMoreButtonHeightConstraintConstant;
static CGFloat expandedTimeAgoBarToMoreButtonDistanceConstraintConstant;

@class CommentBottomBarView;

// TODO: extract all this to a separate UIView class (or maybe even give it a UIViewController)!!!

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonHeightConstraint;

// comment replies tableView
@property (weak, nonatomic) IBOutlet UITableView *repliesTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repliesTableViewHeightConstraint;
@property (strong, nonatomic) RepliesToCommentTableViewController *repliesToCommentTableVC;
@property (assign, nonatomic) BOOL allowInlineReplies;

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
    
  self.repliesTableView.scrollEnabled = NO;
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
  self.allowInlineReplies = NO;
  
  [self setupCommentTextLabelMaxLineCount];
  [self restoreMoreButtonHeightConstraint];
  [self restoreDefaultTimeAgoBarToMoreButtonConstraint];
  
  self.repliesTableView.tableHeaderView = [[CommentRepliesCellConfigurator new] dummyHeaderView];
  self.repliesToCommentTableVC = nil;
}

- (void)setupCommentTextLabelMaxLineCount {
  self.commentLabel.numberOfLines = kMaxFoldedCommentNumberOfLines;
}

#pragma mark TWConfigurableFromDictionary

- (void)configureWithTutorialComment:(TutorialComment *)comment allowInlineCommentReplies:(BOOL)allowInlineReplies {
  AssertTrueOrReturn(comment);
  _comment = comment;
  self.allowInlineReplies = allowInlineReplies;

  self.isCommentReplyCell = (comment.isReplyTo != nil);
  User *commentAuthor = comment.madeBy;
  
  self.authorLabel.text = commentAuthor.name;
  self.commentLabel.text = comment.text;
  [self configureBottomBarWithTutorialComment:comment];
  
  [self updateCellStyling];
  [self updateMoreButtonVisibility];
  [commentAuthor placeAvatarInImageViewOrDisplayPlaceholder:self.avatarImageView placeholderSize:AvatarPlaceholderSize32];
  
  [self showRepliesInvokeCallback];
}

- (void)configureRepliesTableViewIfNeeded {
  BOOL isInitialDataFetch = NO;
  
  if (self.repliesToCommentTableVC == nil && self.allowInlineReplies) {
    isInitialDataFetch = YES;
    self.repliesToCommentTableVC = [RepliesToCommentTableViewController new];
    
    defineWeakSelf();
    VoidBlock sizeCallback = ^() {
      [weakSelf showRepliesInvokeCallback];
    };
    self.repliesToCommentTableVC.tableViewDidLoadDataBlock = sizeCallback;
    
    self.repliesToCommentTableVC.replyCellDidResizeBlock  = ^() {
      // at this point cell is already extended internally, now we just need external tableView to accumulate for expanded size
      DISPATCH_ASYNC_ON_MAIN_THREAD(^{
        sizeCallback();
      });
    };
    
    [self.repliesToCommentTableVC attachToTableView:self.repliesTableView withRepliesToComment:self.comment fetchLimit:@(kInlineRepliesFetchLimit)];
    
    if (isInitialDataFetch) {
      [self.repliesTableView reloadData];
    }
  }
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
    likesCount = (NSUInteger)self.comment.likesCountValue; // fallback value until we have linkedBy relationship populated with data
  }
  return likesCount;
}

- (BOOL)areRepliesExpanded {
  return (self.repliesTableViewHeightConstraint.constant > 0);
}

- (BOOL)commentHasReplies {
  AssertTrueOrReturnNo(self.comment);
  return (self.comment.hasReplies.count > 0);
}

#pragma mark - Repliess

- (void)showReplies {
    if ([self shouldShowMoreRepliesHeaderView]) {
      self.repliesTableView.tableHeaderView = [[CommentRepliesCellConfigurator new] moreRepliesBarWithPressedActionTarget:self selector:@selector(replyButtonPressed:)];
    }
  
    CGFloat constant = self.repliesTableView.contentSize.height;
    self.repliesTableViewHeightConstraint.constant = constant;
}

- (BOOL)shouldShowMoreRepliesHeaderView {
  return ([self.repliesToCommentTableVC fetchedObjects] == kInlineRepliesFetchLimit);
}

- (void)hideReplies {
    self.repliesTableViewHeightConstraint.constant = 0;
    self.repliesTableView.tableHeaderView = [[CommentRepliesCellConfigurator new] dummyHeaderView];
}

#pragma mark - public

- (BOOL)isExpanded {
  return (self.expanded || [self shouldHideMoreButton]); // lineCount equals either 0 or <= maxNrOfLines
}

- (BOOL)canHaveExpandedState {
  BOOL numberOfLinesBelowThreshold = ([self.commentLabel tw_lineCount] <= kMaxFoldedCommentNumberOfLines);
  return !numberOfLinesBelowThreshold;
}

- (void)expandCell {
  BOOL bothBeforeAndAfterAnimationBlocksSet = (self.willChangeCellHeightBlock && self.didChangeCellHeightBlock);
  AssertTrueOrReturn(bothBeforeAndAfterAnimationBlocksSet && "either none of the blocks or both have to be set (willChange.. should call beginUpdates on tableView and didChange should call endUpdates");
  
  CallBlock(self.willChangeCellHeightBlock);
  self.commentLabel.numberOfLines = 0; // this will trigger animations if willChange/didChange blocks contain calls to beginUpdates and endUpdates on tableView
  [self hideMoreButton]; // cell extended, we don't need more button anymore
  self.expanded = YES;

  // update cell height
  [self updateElementsSpacingConstraintsInvokingHeightChangeCallback:YES];
  
  // update main comment tableView height to adjust to new cell size (if there's main tableView)
  CallBlock(self.updateCommentsTableViewFooterHeight) // this should be called multiple times, not just once!
}

- (void)setHighlighted:(BOOL)highlighted {
  UIColor *backgroundColor = self.defaultBackgroundColor;
  if (highlighted) {
    backgroundColor = [ColorsHelper editedCommentTableViewCellBackgroundColor];
  }
  self.contentView.backgroundColor = backgroundColor;
}

- (CGFloat)commentLabelWidth {
    return self.commentLabel.tw_width;
}

- (void)setPreferredCommentLabelMaxLayoutWidth:(CGFloat)preferredWidth {
    self.commentLabel.preferredMaxLayoutWidth = preferredWidth;
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
  return ![self canHaveExpandedState];
}

- (void)hideMoreButton {
  self.moreButton.hidden = YES;
  [self shrinkMoreButtonHeight];
}

- (void)updateCellStyling {
  [self updateAvatarSize];
  [self updateLeftMarginWidth];
  [self layoutIfNeeded];
}

- (void)updateAvatarSize {
  CGFloat avatarEdgeLength = 32.0;
  
  if (self.isCommentReplyCell) {
    avatarEdgeLength = 26.0;
  }
  self.avatarImageViewWidthConstraint.constant = avatarEdgeLength;
  [self layoutIfNeeded]; // required to recalculate frame before updating corner radius
  
  [self.avatarImageView makeCircularSetAspectFit];
}

- (void)updateLeftMarginWidth {
  CGFloat margin = 0;
  
  if (self.isCommentReplyCell) {
    margin = 38.0;
  }
  self.leftMarginWidthConstraint.constant = margin;
}

#pragma mark - Constraints manipulation - elements spacing

/** Watch out when executing this method invoking callback - if you call didChangeCellHeight block, you must 
 * have called willChangeCellHeight first - otherwise it might crash */
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

#pragma mark - Replies Animations

- (void)showRepliesInvokeCallback {
  [self configureRepliesTableViewIfNeeded];
  
  AssertTrueOrReturn(self.willChangeCellHeightBlock != nil);
  CallBlock(self.willChangeCellHeightBlock);
  
  [self showReplies];
  [self updateElementsSpacingConstraintsInvokingHeightChangeCallback:YES];
  
  AssertTrueOrReturn(self.updateCommentsTableViewFooterHeight);
  CallBlock(self.updateCommentsTableViewFooterHeight); // that's required to propagate size changes to main tableView footer
}

- (void)hideRepliesInvokeCallback {
  CallBlock(self.willChangeCellHeightBlock);
  [self hideReplies];
  [self layoutIfNeeded];
  [self updateElementsSpacingConstraintsInvokingHeightChangeCallback:YES];
  CallBlock(self.updateCommentsTableViewFooterHeight);
}

@end
