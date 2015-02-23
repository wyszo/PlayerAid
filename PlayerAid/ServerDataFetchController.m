//
//  PlayerAid
//

#import "ServerDataFetchController.h"
#import "UsersController.h"


@implementation ServerDataFetchController

+ (void)updateUserAndTutorials
{
  [[UsersController sharedInstance] updateUserProfile];
  
  // [[TutorialsController sharedInstance] updateTutorialsList];
  // if this is the first time we fetch tutorials - show blocking alert view on failure (and retry)!
}

@end
