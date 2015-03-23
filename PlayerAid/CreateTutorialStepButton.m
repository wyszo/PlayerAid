//
//  PlayerAid
//

#import "CreateTutorialStepButton.h"
#import "UIView+XibLoading.h"


static NSString *const kNibFileName = @"CreateTutorialStepButton";


@interface CreateTutorialStepButton ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIView *view;

@end


@implementation CreateTutorialStepButton

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self loadView:self.view fromNibNamed:kNibFileName];
  }
  return self;
}

#pragma mark - IBActions

- (IBAction)buttonPressed:(id)sender
{
}

@end
