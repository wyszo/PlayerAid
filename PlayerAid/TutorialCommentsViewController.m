//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "TutorialCommentsViewController.h"
#import "ColorsHelper.h"
#import "TutorialCommentsController.h"

static NSString * const kXibFileName = @"TutorialComments";

@interface TutorialCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIView *commentsBar;
@property (strong, nonatomic) TutorialCommentsController *commentsController;
@property (strong, nonatomic) Tutorial *tutorial;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@end

@implementation TutorialCommentsViewController

#pragma mark - Init

- (nonnull instancetype)initWithTutorial:(nonnull Tutorial *)tutorial
{
  self = [super initWithNibName:kXibFileName bundle:nil];
  if (self) {
    _tutorial = tutorial;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.commentsBar.backgroundColor = [ColorsHelper tutorialCommentsBarBackgroundColor];
  [self setupCommentsController];
  [self refreshCommentsCountLabel];
}

- (void)setupCommentsController
{
  defineWeakSelf();
  self.commentsController = [[TutorialCommentsController alloc] initWithTutorial:self.tutorial commentsCountChangedBlock:^{
    [weakSelf refreshCommentsCountLabel];
  }];
}

#pragma mark - UI Updates

- (void)refreshCommentsCountLabel
{
  NSInteger commentsCount = self.tutorial.hasComments.count;
  self.commentsCountLabel.text = [NSString stringWithFormat:@"%lu Comments", commentsCount];
}

@end
