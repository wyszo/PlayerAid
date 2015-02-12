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

#pragma mark - IBActions

- (IBAction)photoButtonPressed:(id)sender
{
  [self.delegate addPhotoStepSelected];
}

- (IBAction)videoButtonPressed:(id)sender
{
  [self.delegate addVideoStepSelected];
}

- (IBAction)textButtonPressed:(id)sender
{
  [self.delegate addTextStepSelected];
}

@end
