//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "TutorialCommentCell.h"
#import "User.h"
#import "UIImageView+AvatarStyling.h"

@interface TutorialCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation TutorialCommentCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self.avatarImageView makeCircular];
  [self tw_configureForFullWidthSeparators];
}

- (void)configureWithTutorialComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  User *commentAuthor = comment.madeBy;
  
  self.authorLabel.text = commentAuthor.name;
  self.commentLabel.text = comment.text;
  
  [commentAuthor placeAvatarInImageView:self.avatarImageView];
}

@end
