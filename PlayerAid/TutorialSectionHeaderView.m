//
//  PlayerAid
//

#import "TutorialSectionHeaderView.h"
#import "UIView+XibLoading.h"

static NSString *const kNibName = @"TutorialsSectionHeaderView";


@implementation TutorialSectionHeaderView

- (instancetype)init
{
  self = [super initWithFrame:CGRectZero];
  if (self) {
    [self loadView:self fromNibNamed:kNibName];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self loadView:self fromNibNamed:kNibName];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self loadView:self fromNibNamed:kNibName];
  }
  return self;
}

@end
