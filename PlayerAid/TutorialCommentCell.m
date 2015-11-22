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

@interface TutorialCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@end

@implementation TutorialCommentCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self.avatarImageView makeCircular];
  [self tw_configureForFullWidthSeparators];
  self.timeAgoLabel.textColor = [ColorsHelper commentsTimeAgoLabelColor];
  [self setupCommentTextLabel];
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  self.avatarImageView.image = nil;
  [self.avatarImageView cancelImageRequestOperation];
}

- (void)setupCommentTextLabel
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

#pragma mark - private

- (void)updateMoreButtonVisibility
{
  self.moreButton.hidden = ([self.commentLabel tw_lineCount] <= kMaxFoldedCommentNumberOfLines);
}

#pragma mark - IBActions

- (IBAction)moreButtonPressed:(id)sender {
  BOOL bothBeforeAndAfterAnimationBlocksSet = (self.willChangeCellHeightBlock && self.didChangeCellHeightBlock);
  AssertTrueOrReturn(bothBeforeAndAfterAnimationBlocksSet && "either none of the blocks or both have to be set (willChange.. should call beginUpdates on tableView and didChange should call endUpdates");
  
  CallBlock(self.willChangeCellHeightBlock);
  self.commentLabel.numberOfLines = 0; // this will trigger animations if willChange/didChange blocks contain calls to beginUpdates and endUpdates on tableView
  self.moreButton.hidden = YES; // cell extended, we don't need it anymore
  CallBlock(self.didChangeCellHeightBlock);
}

@end
