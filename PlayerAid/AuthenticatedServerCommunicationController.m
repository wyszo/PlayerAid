//
//  PlayerAid
//

#import <AFNetworking.h>
#import "AuthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"
#import "Section.h"


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

- (void)getCurrentUserCompletion:(NetworkResponseBlock)completion
{
  [self getRequestWithApiToken:self.apiToken urlString:@"user" useCacheIfAllowed:YES completion:completion];
}

- (void)getUserWithID:(NSString *)userID completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(userID.length);
  NSString *urlString = [@"user/" stringByAppendingString:userID];
  [self getRequestWithApiToken:self.apiToken urlString:urlString useCacheIfAllowed:YES completion:completion];
}

#pragma mark - Tutorial management

- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion
{
  AssertTrueOrReturn(tutorial.serverID);
  NSString *URLString = [self urlStringForTutorialID:tutorial.serverID];
  
  [self.requestOperationManager DELETE:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) completion(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(error);
    }
  }];
}

- (NSString *)urlStringForTutorialID:(NSNumber *)tutorialID
{
  return [self urlStringForTutorialIDString:tutorialID.stringValue];
}

- (NSString *)urlStringForTutorialIDString:(NSString *)tutorialID
{
  AssertTrueOrReturnNil(tutorialID.length);
  return [NSString stringWithFormat:@"v1/tutorial/%@", tutorialID];
}

- (void)createTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(tutorial.title.length);
  AssertTrueOrReturn(tutorial.section.name);
  
  NSDictionary *parameters = @{
                               @"title" : tutorial.title,
                               @"section" : tutorial.section.name,
                               @"CreatedOn" : [NSDate new]
                              };
  
  [self postRequestWithApiToken:self.apiToken urlString:@"tutorial" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (completion) {
      completion(response, responseObject, error);
    }
  }];
}

- (void)submitImageForTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(tutorial.pngImageData);
  NSString *tutorialID = [tutorial.serverID stringValue];
  AssertTrueOrReturn(tutorialID);
  
  NSDictionary *parameters = @{
                               @"id" : tutorialID,
                               @"contentType" : @"image/png",
                               @"imageData" : tutorial.pngImageData
                              };
  
  NSString *URLString = [NSString stringWithFormat:@"%@/image", [self urlStringForTutorialIDString:tutorialID]];
  [self postRequestWithApiToken:self.apiToken urlString:URLString parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (completion) {
      completion(response, responseObject, error);
    }
  }];
}

- (void)submitTutorialForReview:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(tutorial);
  
  NSDictionary *parameters = @{
                               @"id" : tutorial.serverID.stringValue
                              };
  NSString *URLString = [self urlStringForTutorialID:tutorial.serverID];
  [self postRequestWithApiToken:self.apiToken urlString:URLString parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (completion) {
      completion(response, responseObject, error);
    }
  }];
}

#pragma mark - Sending requests

- (void)getRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  [self requestWithType:@"GET" apiToken:apiToken urlString:urlString parameters:nil useCacheIfAllowed:useCache completion:completion];
}

- (void)postRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString parameters:(id)parameters completion:(NetworkResponseBlock)completion
{
  [self requestWithType:@"POST" apiToken:apiToken urlString:urlString parameters:parameters useCacheIfAllowed:NO completion:completion];
}

- (void)requestWithType:(NSString *)requestType apiToken:(NSString *)apiToken urlString:(NSString *)urlString parameters:(id)parameters useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(requestType.length);
  AssertTrueOrReturn(urlString.length);
  AssertTrueOrReturn(completion);
  
  AFHTTPRequestOperationManager *operationManager = [self operationManageWithApiToken:apiToken useCacheIfAllowed:useCache];

  NSString *selectorString = [requestType stringByAppendingString:@":parameters:success:failure:"];
  SEL selector = NSSelectorFromString(selectorString);
  AssertTrueOrReturn([operationManager respondsToSelector:selector]);
  
  [self invokeAFNetworkingOperationWithReuqestWithSelector:selector operationManager:operationManager urlString:urlString parameters:(id)parameters successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) {
      completion(operation.response, responseObject, nil);
    }
  } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(operation.response, nil, error);
    }
  }];
}

- (void)invokeAFNetworkingOperationWithReuqestWithSelector:(SEL)selector operationManager:(AFHTTPRequestOperationManager *)operationManager urlString:(NSString *)urlString parameters:(id)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
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
  if (parameters) { [invocation setArgument:&parameters atIndex:3]; }
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
