//
//  PlayerAid
//

#import "CreateTutorialStepButtonsContainerView.h"
#import "UIView+TWXibLoading.h"
#import "CreateTutorialStepButton.h"


static NSString *const kNibFileName = @"CreateTutorialStepButtonsContainerView";


@interface CreateTutorialStepButtonsContainerView ()

@property (strong, nonatomic) UIView *view;

@property (weak, nonatomic) IBOutlet CreateTutorialStepButton *photoStepButton;
@property (weak, nonatomic) IBOutlet CreateTutorialStepButton *videoStepButton;
@property (weak, nonatomic) IBOutlet CreateTutorialStepButton *textStepButton;

@end


@implementation CreateTutorialStepButtonsContainerView

#pragma mark - View Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
    [self setupButtons];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self tw_loadView:self.view fromNibNamed:kNibFileName];
    [self setupButtons];
  }
  return self;
}

#pragma mark - View Customization 

- (void)setupButtons
{
  defineWeakSelf();
  
  [self.photoStepButton configureWithTitle:@"Add Photo" imageNamed:@"camerabtn" actionBlock:^{
    [weakSelf.delegate addPhotoStepSelected];
  }];
  
  [self.videoStepButton configureWithTitle:@"Add Video" imageNamed:@"videobtn" actionBlock:^{
    [weakSelf.delegate addVideoStepSelected];
  }];
  
  [self.textStepButton configureWithTitle:@"Add Text" imageNamed:@"textbtn" actionBlock:^{
    [weakSelf.delegate addTextStepSelected];
  }];
}

@end
