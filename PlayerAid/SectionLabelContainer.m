//
//  PlayerAid
//

#import "SectionLabelContainer.h"
#import "UIView+XibLoading.h"

static NSString *const kNibFileName = @"SectionLabelContainerView";


@interface SectionLabelContainer ()
@property (nonatomic, weak) UIView *view;
@end


@implementation SectionLabelContainer

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

@end
