//
//  PlayerAid
//

#import <AFNetworking.h>
#import "ServerCommunicationController.h"
#import "KZAsserts.h"


static NSString* kServerBaseURL = @"http://api.playeraid.co.uk/v1/";


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

#pragma mark - Authentication

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

#pragma mark - Ping

- (void)pingWithApiToken:(NSString *)apiToken completion:(void (^)(NSHTTPURLResponse *response, NSError *erorr))completion
{
  [self postRequestWithApiToken:apiToken urlString:@"ping" completion:completion];
}

#pragma mark - Users management

- (void)postUserWithApiToken:(NSString *)apiToken completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion
{
  [self postRequestWithApiToken:apiToken urlString:@"user" completion:completion];
}

#pragma mark - Tutorial management

- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion
{
  AssertTrueOrReturn(tutorial);
  
  NSString *tutorialID; // TODO: extract ID from Tutorial object
  AssertTrueOrReturn(tutorialID);
  NSString *URLString = [NSString stringWithFormat:@"tutorial/%@", tutorialID];
  
  [self.requestOperationManager DELETE:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) completion(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(error);
    }
  }];
}

#pragma mark - Auxiliary methods

- (void)postRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion
{
  AssertTrueOrReturn(apiToken.length);
  AssertTrueOrReturn(urlString.length);
  AssertTrueOrReturn(completion);
  
  NSString *bearer = [[NSString alloc] initWithFormat:@"Bearer %@", apiToken];
  [self.requestOperationManager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
  
  [self.requestOperationManager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) {
      completion(operation.response, nil);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(operation.response, error);
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