//
//  PlayerAid
//

#import "LoginManager.h"
#import "AuthenticationController_SavingToken.h"
#import "AuthenticatedServerCommunicationController.h"
#import "ServerDataUpdateController.h"

@implementation LoginManager

- (void)loginWithApiToken:(nonnull NSString *)apiToken completion:(nullable VoidBlockWithError)completion
{
  AssertTrueOrReturn(apiToken.length);
  
  [AuthenticationController saveApiAuthenticationTokenToUserDefaults:apiToken];
  [AuthenticatedServerCommunicationController setApiToken:apiToken];
  [ServerDataUpdateController updateUserAndTutorials];
  
  CallBlock(completion, nil);
}

@end
