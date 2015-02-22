//
//  PlayerAid
//

#import <AFNetworking.h>
#import "UnauthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"


@implementation AuthenticationRequestData
@end


@interface UnauthenticatedServerCommunicationController()
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@end


@implementation UnauthenticatedServerCommunicationController

+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Authentication

+ (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion
{
  [[self sharedInstance] requestAPITokenWithAuthenticationRequestData:data completion:completion];
}

- (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion
{
  AssertTrueOrReturn(data.facebookAuthenticationToken);
  AssertTrueOrReturn(data.email);
  
  NSDictionary *parameters = @{
                               @"token" : data.facebookAuthenticationToken,
                               @"email" : data.email
                               };
  [self.requestOperationManager POST:@"auth" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
  NSURL *url = [NSURL URLWithString:(NSString *)kServerBaseURL];
  
  if (!_requestOperationManager) {
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  }
  return _requestOperationManager;
}

@end
