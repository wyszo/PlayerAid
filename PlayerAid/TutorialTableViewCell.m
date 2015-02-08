//
//  PlayerAid
//

#import "TutorialTableViewCell.h"
#import "UIImageView+AvatarStyling.h"
#import "User.h"
#import "Section.h"


@interface TutorialTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@end


@implementation TutorialTableViewCell

- (void)awakeFromNib
{
  [self.avatarImageView styleAsSmallAvatar];
}

- (void)configureWithTutorial:(Tutorial *)tutorial
{
  self.titleLabel.text = tutorial.title;
  self.authorLabel.text = tutorial.createdBy.username;
  self.sectionLabel.text = tutorial.section.name;
//  self.timeLabel.text = // tutorial.createdAt -> string // TODO: display creation date
  
  self.avatarImageView.image = tutorial.createdBy.avatarImage;
//  self.favouriteButton // TODO: turn favourite button on/off
  
  [self adjustAlphaFromTutorial:tutorial];
}

-(void)adjustAlphaFromTutorial:(Tutorial *)tutorial
{
  CGFloat alpha = 1.0f;
  
  if (tutorial.primitiveDraftValue) {
    alpha = 0.5f;
  }
  else if (tutorial.primitiveInReviewValue) {
    alpha = 0.75f;
  }
  self.contentView.alpha = alpha;
}

@end
