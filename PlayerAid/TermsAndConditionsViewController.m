//
//  PlayerAid
//

#import "TermsAndConditionsViewController.h"

@implementation TermsAndConditionsViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Statusbar handling

- (BOOL)prefersStatusBarHidden
{
  return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

@end
