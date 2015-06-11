//
//  PlayerAid
//

#import "PlayerInfoSegmentedControlButtonView.h"
#import "UIView+TWXibLoading.h"


static NSString *const kNibFileName = @"PlayerInfoSegmentedControlButtonView";


@interface PlayerInfoSegmentedControlButtonView ()

@property (strong, nonatomic) UIView *view;

@end;


@implementation PlayerInfoSegmentedControlButtonView

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
    [self customize];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
    [self customize];
  }
  return self;
}

- (void)customize
{
  self.topLabel.textColor = [UIColor whiteColor];
  self.bottomLabel.textColor = [UIColor whiteColor];
}

@end
