//
//  PlayerAid
//

#import <NSManagedObject+MagicalFinders.h>
#import "ProfileViewController.h"
#import "PlayerInfoView.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet PlayerInfoView *playerInfoView;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.playerInfoView.user = [User MR_findFirst]; // TODO: hook up correct user in here!
}

@end
