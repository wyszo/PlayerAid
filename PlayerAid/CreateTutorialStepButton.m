//
//  PlayerAid
//

#import "CreateTutorialStepButton.h"
#import "UIView+TWXibLoading.h"


static NSString *const kNibFileName = @"CreateTutorialStepButton";


@interface CreateTutorialStepButton ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) UIView *view;
@property (copy, nonatomic) VoidBlock actionBlock;

@end


@implementation CreateTutorialStepButton

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

#pragma mark - View Customization

- (void)configureWithTitle:(NSString *)title imageNamed:(NSString *)imageName actionBlock:(VoidBlock)action
{
  self.titleLabel.text = title;
  self.imageView.image = [UIImage imageNamed:imageName];
  self.actionBlock = action;
}

#pragma mark - IBActions

- (IBAction)buttonPressed:(id)sender
{
  if (self.actionBlock) {
    self.actionBlock();
  }
}

@end
