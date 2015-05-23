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

- (void)pingCompletion:(NetworkResponseBlock)completion
{
  [self getRequestWithApiToken:self.apiToken urlString:@"ping" useCacheIfAllowed:NO completion:completion];
}

#pragma mark - Users management

- (void)getUserCompletion:(NetworkResponseBlock)completion
{
  [self getRequestWithApiToken:self.apiToken urlString:@"user" useCacheIfAllowed:YES completion:completion];
}

#pragma mark - Tutorial management

- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion
{
  AssertTrueOrReturn(tutorial.serverID);
  NSString *URLString = [NSString stringWithFormat:@"tutorial/%@", tutorial.serverID];
  
  [self.requestOperationManager DELETE:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) completion(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(error);
    }
  }];
}

#pragma mark - Sending requests

- (void)getRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  [self requestWithType:@"GET" apiToken:apiToken urlString:urlString useCacheIfAllowed:useCache completion:completion];
}

- (void)postRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  [self requestWithType:@"POST" apiToken:apiToken urlString:urlString useCacheIfAllowed:useCache completion:completion];
}

- (void)requestWithType:(NSString *)requestType apiToken:(NSString *)apiToken urlString:(NSString *)urlString useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(requestType.length);
  AssertTrueOrReturn(urlString.length);
  AssertTrueOrReturn(completion);
  
  AFHTTPRequestOperationManager *operationManager = [self operationManageWithApiToken:apiToken useCacheIfAllowed:useCache];

  NSString *selectorString = [requestType stringByAppendingString:@":parameters:success:failure:"];
  SEL selector = NSSelectorFromString(selectorString);
  AssertTrueOrReturn([operationManager respondsToSelector:selector]);
  
  [self invokeAFNetworkingOperationWithReuqestWithSelector:selector operationManager:operationManager urlString:urlString successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) {
      completion(operation.response, responseObject, nil);
    }
  } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(operation.response, nil, error);
    }
  }];
}

- (void)invokeAFNetworkingOperationWithReuqestWithSelector:(SEL)selector operationManager:(AFHTTPRequestOperationManager *)operationManager urlString:(NSString *)urlString successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
  AssertTrueOrReturn(selector);
  AssertTrueOrReturn(operationManager);
  AssertTrueOrReturn(urlString.length);
  
  NSMethodSignature *methodSignature = [operationManager methodSignatureForSelector:selector];
  AssertTrueOrReturn(methodSignature);
  
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [invocation setTarget:operationManager];
  [invocation setSelector:selector];
  
  [invocation setArgument:&urlString atIndex:2]; // indexes 0 and 1 are reserved
  if (successBlock) { [invocation setArgument:&successBlock atIndex:4]; }
  if (failureBlock) { [invocation setArgument:&failureBlock atIndex:5]; }
  [invocation invoke];
}

- (AFHTTPRequestOperationManager *)operationManageWithApiToken:(NSString *)apiToken useCacheIfAllowed:(BOOL)useCache
{
  AssertTrueOrReturnNil(apiToken.length);
  AFHTTPRequestOperationManager *operationManager = self.requestOperationManager;
  NSString *bearer = [[NSString alloc] initWithFormat:@"Bearer %@", apiToken];
  [operationManager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
  
  operationManager.requestSerializer.cachePolicy = (useCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData);
  return operationManager;
}

#pragma mark - Lazy initialization

- (AFHTTPRequestOperationManager *)requestOperationManager
{
  NSURL *url = [NSURL URLWithString:(NSString *)kServerBaseURL];
  
  if (!_requestOperationManager) {
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  }
  _requestOperationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy; // reset to default cache
  return _requestOperationManager;
}

@end
