//
//  PlayerAid
//

#import <AFNetworking.h>
#import "AuthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"



@interface AuthenticatedServerCommunicationController ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, strong) NSString *apiToken;
@end

@implementation AuthenticatedServerCommunicationController

+ (instancetype)sharedInstance
{
  /* Technical debt: could easily avoid making a singleton here */
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

+ (void)setApiToken:(NSString *)apiToken
{
  AssertTrueOrReturn(apiToken.length);
  ((AuthenticatedServerCommunicationController *)[self sharedInstance]).apiToken = apiToken;
}

#pragma mark - Ping

- (void)pingCompletion:(void (^)(NSHTTPURLResponse *response, NSError *erorr))completion
{
  [self postRequestWithApiToken:self.apiToken urlString:@"ping" completion:completion];
}

#pragma mark - Users management

- (void)postUserCompletion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion
{
  [self postRequestWithApiToken:self.apiToken urlString:@"user" completion:completion];
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