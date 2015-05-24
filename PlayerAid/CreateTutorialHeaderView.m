//
//  PlayerAid
//

#import "CreateTutorialHeaderView.h"
#import "UIView+TWXibLoading.h"

static NSString *const kNibFileName = @"CreateTutorialHeaderView";


@interface CreateTutorialHeaderView ()
@property (nonatomic, weak) UIView *view;

@end


@implementation CreateTutorialHeaderView

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


@end
