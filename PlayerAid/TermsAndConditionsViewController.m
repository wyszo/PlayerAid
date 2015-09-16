//
//  PlayerAid
//

#import "TermsAndConditionsViewController.h"
#import <TWCommonLib/NSString+TWHTMLString.h>

static NSString *const kTermsAndConditionsHTMLFileName = @"T&Cs.html";


@interface TermsAndConditionsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end


@implementation TermsAndConditionsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadWebViewContent];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadWebViewContent
{
  NSString *htmlString = [NSString tw_htmlStringFromFileNamed:kTermsAndConditionsHTMLFileName];
  AssertTrueOrReturn(htmlString.length);
  [self.webView loadHTMLString:htmlString baseURL:nil];
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
