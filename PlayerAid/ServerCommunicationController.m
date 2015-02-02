//
//  PlayerAid
//

#import <AFNetworking.h>
#import "ServerCommunicationController.h"
#import "KZAsserts.h"


static NSString* kServerBaseURL = @"http://api.playeraid.co.uk";


@implementation AuthenticationRequestData
@end


@interface ServerCommunicationController ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@end

@implementation ServerCommunicationController

+ (ServerCommunicationController *)sharedInstance
{
  /* Technical debt: could easily avoid making a singleton here */
  static ServerCommunicationController *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

+ (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion
{
  AssertTrueOrReturn(data.facebookAuthenticationToken);
  AssertTrueOrReturn(data.email);
  
  NSDictionary *parameters = @{
                               @"token" : data.facebookAuthenticationToken,
                               @"email" : data.email
                              };
  [self.sharedInstance.requestOperationManager POST:@"/api/v1/auth" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) {
      completion(operation.response, nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(nil, error);
    }
  }];
}


#pragma mark - Lazy initialization

- (AFHTTPRequestOperationManager *)requestOperationManager
{
  NSURL *url = [NSURL URLWithString:kServerBaseURL];
  
  if (!_requestOperationManager) {
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  }
  return _requestOperationManager;
}

@end