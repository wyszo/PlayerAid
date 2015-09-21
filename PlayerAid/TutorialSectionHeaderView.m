//
//  PlayerAid
//

#import <TWCommonLib/UIView+TWXibLoading.h>
#import "TutorialSectionHeaderView.h"

static NSString *const kNibName = @"TutorialsSectionHeaderView";


@implementation TutorialSectionHeaderView

- (instancetype)init
{
  self = [super initWithFrame:CGRectZero];
  if (self) {
    [self tw_loadView:self fromNibNamed:kNibName];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self tw_loadView:self fromNibNamed:kNibName];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self tw_loadView:self fromNibNamed:kNibName];
  }
  return self;
}

@end
