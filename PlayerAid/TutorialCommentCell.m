//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "TutorialCommentCell.h"

@interface TutorialCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TutorialCommentCell

- (void)configureWithTutorialComment:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  self.titleLabel.text = comment.text;
}

@end
