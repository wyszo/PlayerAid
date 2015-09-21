//
//  PlayerAid
//

#import <TWCommonLib/UIView+TWXibLoading.h>
#import "PopoverView.h"

static NSString *const kNibFileName = @"PopoverView";


@interface PopoverView ()

@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (strong, nonatomic) UIView *view;

@end


@implementation PopoverView

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

#pragma mark - UI customization

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.bubbleImageView.image = [self scaledBubbleResizableImage];
}

- (UIImage *)scaledBubbleResizableImage
{
  UIImage *fullSizeImage = [UIImage imageNamed:@"bubble"];
  UIImage *halfSizeImage = [UIImage imageWithCGImage:fullSizeImage.CGImage scale:4.0f orientation:fullSizeImage.imageOrientation];
  return [halfSizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

@end
