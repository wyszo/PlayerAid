//
//  PlayerAid
//

#import "PrivacyPolicyViewController.h"

static NSString *const kPrivacyPolicyHTMLFileName = @"PrivacyPolicy.html";


@interface PrivacyPolicyViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadWebViewContent];
}

- (void)loadWebViewContent
{
  NSString *htmlString = [NSString tw_htmlStringFromFileNamed:kPrivacyPolicyHTMLFileName];
  AssertTrueOrReturn(htmlString.length);
  [self.webView loadHTMLString:htmlString baseURL:nil];
}

@end
