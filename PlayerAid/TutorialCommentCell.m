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
  [self setupCommentLabel];
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  self.avatarImageView.image = nil;
  [self.avatarImageView cancelImageRequestOperation];
}

- (void)setupCommentLabel
{
  self.commentLabel.numberOfLines = kMaxFoldedCommentNumberOfLines;
}

#pragma mark - IBActions

- (IBAction)moreButtonPressed:(id)sender {
  BOOL bothBeforeAndAfterAnimationBlocksSet = (self.willChangeCellHeightBlock && self.didChangeCellHeightBlock);
  AssertTrueOrReturn(bothBeforeAndAfterAnimationBlocksSet && "either none of the blocks or both have to be set (willChange.. should call beginUpdates on tableView and didChange should call endUpdates");
  
  CallBlock(self.willChangeCellHeightBlock);
  self.commentLabel.numberOfLines = 0; // this will trigger animations if willChange/didChange blocks contain calls to beginUpdates and endUpdates on tableView
  CallBlock(self.didChangeCellHeightBlock);
}

#pragma mark TWConfigurableFromDictionary

- (void)configureWithTutorialComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  User *commentAuthor = comment.madeBy;
  
  self.authorLabel.text = commentAuthor.name;
  self.commentLabel.text = comment.text;
  self.timeAgoLabel.text = [comment.createdOn shortTimeAgoSinceNow];
  
  [commentAuthor placeAvatarInImageView:self.avatarImageView];
}

@end
