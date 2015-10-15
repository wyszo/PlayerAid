//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "NoTutorialsView.h"

static NSString *const kNibFileName = @"NoTutorialsView";

@interface NoTutorialsView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;
@property (strong, nonatomic) UIView *view;
@end

@implementation NoTutorialsView

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

#pragma mark - Public interface 

- (void)setText:(nullable NSString *)text imageNamed:(nullable NSString *)imageName
{
  UIImage *image;
  if (imageName.length) {
    image = [UIImage imageNamed:imageName];
    AssertTrueOr(image,);
  }
  
  self.noTutorialsLabel.text = text;
  self.imageView.image = image;
}

@end
