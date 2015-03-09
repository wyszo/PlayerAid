//
//  PlayerAid
//

#import "PopoverView.h"
#import "UIView+XibLoading.h"

static NSString *const kNibFileName = @"PopoverView";


@interface PopoverView ()

@property (weak, nonatomic) IBOutlet UIImageView *bubbleImage;
@property (strong, nonatomic) UIView *view;

@end


@implementation PopoverView

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

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.bubbleImage.image = [[UIImage imageNamed:@"bubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

@end
