//
//  PlayerAid
//

#import "CreateTutorialHeaderView.h"
#import "UIView+XibLoading.h"

static NSString *const kNibFileName = @"CreateTutorialHeaderView";


@interface CreateTutorialHeaderView ()
@property (nonatomic, weak) UIView *view;

@end


@implementation CreateTutorialHeaderView

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
