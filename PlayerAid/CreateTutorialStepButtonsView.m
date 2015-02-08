//
//  PlayerAid
//

#import "CreateTutorialStepButtonsView.h"
#import "UIView+XibLoading.h"


static NSString *const kNibFileName = @"CreateTutorialStepButtonsView";


@interface CreateTutorialStepButtonsView ()
@property (strong, nonatomic) UIView *view;
@end


@implementation CreateTutorialStepButtonsView

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

@end
