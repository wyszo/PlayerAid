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
