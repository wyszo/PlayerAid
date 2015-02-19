//
//  PlayerAid
//

#import "UsersController.h"
#import "ServerCommunicationController.h"


@implementation UsersController

+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)updateUserProfile
{
  // TODO: send /user network request
  [[ServerCommunicationController sharedInstance] postUserWithApiToken:nil completion:^(NSError *error) {
    if (error) {
      // if first request ever - block UI
      // else - retry every 10s
    } else {
      // TODO: handle response
    }
  }];
  
  NSAssert(false, @"Not fully implemented yet!!!");
}

@end
