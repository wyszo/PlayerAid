//
//  PlayerAid
//

@import TWCommonLib;
#import "IntroViewController.h"
#import "ColorsHelper.h"

@interface IntroViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end


@implementation IntroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [ColorsHelper playerAidBlueColor];
  [self skinButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

#pragma mark - Skinning

- (void)skinButtons
{
  [self skinButton:self.loginButton];
  [self skinButton:self.signUpButton];
}

- (void)skinButton:(UIButton *)button
{
  button.backgroundColor = [UIColor clearColor];
  [button tw_addBorderWithWidth:1.0 color:[UIColor whiteColor]];
  [button tw_setCornerRadius:8.0];
}

#pragma mark - Helper methods

- (void)dismissViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
