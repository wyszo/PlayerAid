//
//  PlayerAid
//

#import "HomeViewController.h"
#import "TutorialsTableDataSource.h"
#import "TutorialDetailsViewController.h"
#import "ColorsHelper.h"
#import "ProfileViewController.h"
#import "ApplicationViewHierarchyHelper.h"
#import "DebugSettings.h"
#import "VideoPlayer.h"
#import "TutorialDetailsHelper.h"



@interface HomeViewController () <TutorialsTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *latestFilterBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *followingFilterBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *latestFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *followingFilterButton;

@property (strong, nonatomic) TutorialsTableDataSource *tutorialsTableDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tutorialsTableView;
@property (weak, nonatomic) IBOutlet UILabel *noTutorialsLabel;

@property (weak, nonatomic) Tutorial *lastSelectedTutorial;

@property (nonatomic, strong) TWShowOverlayWhenTableViewEmptyBehaviour *tableViewOverlayBehaviour;
@property (nonatomic, strong) VideoPlayer *videoPlayer;

@end


@implementation HomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Home";
  self.videoPlayer = [[VideoPlayer tw_lazy] initWithParentViewController:self.tabBarController];
  
  self.tutorialsTableDataSource = [[TutorialsTableDataSource alloc] initAttachingToTableView:self.tutorialsTableView];
  
  self.tutorialsTableDataSource.predicate = [NSPredicate predicateWithFormat:@"state == %@", kTutorialStatePublished];
  self.tutorialsTableDataSource.tutorialTableViewDelegate = self;
  self.tutorialsTableDataSource.userAvatarSelectedBlock = [ApplicationViewHierarchyHelper pushProfileViewControllerFromViewController:self allowPushingLoggedInUser:NO];
  
  [self setupTableViewHeader];
  
  self.noTutorialsLabel.text = @"No tutorials to show yet";
  self.tableViewOverlayBehaviour = [[TWShowOverlayWhenTableViewEmptyBehaviour alloc] initWithTableView:self.tutorialsTableView dataSource:self.tutorialsTableDataSource overlayView:self.noTutorialsLabel allowScrollingWhenNoCells:NO];

  // TODO: Technical debt - we definitely shouldn't delay UI skinning like that!
  [self selectFilterLatest]; // intentional
  defineWeakSelf();
  DISPATCH_AFTER(0.01, ^{
    [weakSelf selectFilterLatest];
  });
  
  // TODO: Filter buttons should be extracted to a separate class!!

  if (DEBUG_TEST_ONLINE_VIDEO_PLAYBACK) {
    DISPATCH_AFTER(1.0, ^{
      NSString *correctUrlString = @"http://playeraid.streaming.mediaservices.windows.net/08865072-191a-4065-9136-3c5cbf30b228/9da92542-14a6-426f-8605-a1774d9cee27-m3u8-aapl.ism/Manifest%28format=m3u8-aapl%29";
      NSString *messedUpUrlString = @"http://messed.up.test.url/";
      
      NSURL *url = [NSURL URLWithString:correctUrlString];
      [weakSelf.videoPlayer presentMoviePlayerAndPlayVideoURL:url];
    });
  }
}

- (void)setupTableViewHeader
{
  // table view header - a white stripe in this case
  const CGFloat kHeaderGapHeight = 18.0f;
  UIView *headerViewGap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kHeaderGapHeight)];
  self.tutorialsTableView.tableHeaderView = headerViewGap;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - latest & following buttons bar

- (IBAction)latestFilterSelected:(id)sender
{
  // TODO: change predicate to show latest tutorials
  
  [self selectFilterLatest];
}

- (void)selectFilterLatest
{
  [self setLatestFilterButtonTextColor:[ColorsHelper tutorialsSelectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsSelectedFilterButtonColor]];
  [self setFollowingFilterButtonTextColor:[ColorsHelper tutorialsUnselectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsUnselectedFilterButtonColor]];
}

- (IBAction)followingFilterSelected:(id)sender
{
  // TODO: change predicate to show tutorials of the users I follow
  
  [self selectFilterFollowing];
}

- (void)selectFilterFollowing
{
  [self setLatestFilterButtonTextColor:[ColorsHelper tutorialsUnselectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsUnselectedFilterButtonColor]];
  [self setFollowingFilterButtonTextColor:[ColorsHelper tutorialsSelectedFilterButtonTextColor] backgroundColor:[ColorsHelper tutorialsSelectedFilterButtonColor]];
}

- (void)setLatestFilterButtonTextColor:(UIColor *)latestColor andFollowingFilterButtonTextColor:(UIColor *)followingColor
{
  self.latestFilterButton.titleLabel.textColor = latestColor;
  self.followingFilterButton.titleLabel.textColor = followingColor;
}

- (void)setLatestFilterButtonTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
  self.latestFilterButton.titleLabel.textColor = textColor;
  self.latestFilterBackgroundView.backgroundColor = backgroundColor;
}

- (void)setFollowingFilterButtonTextColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
  self.followingFilterButton.titleLabel.textColor = textColor;
  self.followingFilterBackgroundView.backgroundColor = backgroundColor;
}

#pragma mark - TutorialTableViewDelegate

- (void)didSelectRowWithTutorial:(Tutorial *)tutorial
{
  self.lastSelectedTutorial = tutorial;
  [[TutorialDetailsHelper new] performTutorialDetailsSegueFromViewController:self];
}

- (void)numberOfRowsDidChange:(NSInteger)numberOfRows
{
  [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [[TutorialDetailsHelper new] prepareForTutorialDetailsSegue:segue pushingTutorial:self.lastSelectedTutorial deallocBlock:nil];
}

@end
