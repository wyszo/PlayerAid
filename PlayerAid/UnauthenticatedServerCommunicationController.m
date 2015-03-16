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
                                          completion:(void (^)(NSHTTPURLResponse *response, id responseObject, NSError *error))completion
{
  [[self sharedInstance] requestAPITokenWithAuthenticationRequestData:data completion:completion];
}

- (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data
                                          completion:(void (^)(NSHTTPURLResponse *response, id responseObject, NSError *error))completion
{
  AssertTrueOrReturn(data.facebookAuthenticationToken);
  AssertTrueOrReturn(data.email);
  
  NSDictionary *parameters = @{
                               @"token" : data.facebookAuthenticationToken,
                               @"email" : data.email
                               };
  
  AFHTTPRequestOperationManager *operationManagerNoCache = [self requestOperationManagerBypassignCache];
  
  NSString *URLString = [self URLStringWithPath:@"auth" baseURL:operationManagerNoCache.baseURL];
  
  NSMutableURLRequest *request = [operationManagerNoCache.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
  AssertTrueOrReturn(request);
  
  [self addHttpHeadersFromDictionary:@{
    @"X-Provider" : @"Facebook"
  } toMutableRequest:request];
  
  AFHTTPRequestOperation *operation = [operationManagerNoCache HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completion) {
      completion(operation.response, responseObject, nil);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(nil, nil, error);
    }
  }];
  
  [operationManagerNoCache.operationQueue addOperation:operation];
}

- (AFHTTPRequestOperationManager *)requestOperationManagerBypassignCache
{
  AFHTTPRequestOperationManager *requestOperationManagerBypassingCache = self.requestOperationManager;
  requestOperationManagerBypassingCache.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  AssertTrueOrReturnNil(requestOperationManagerBypassingCache);
  return requestOperationManagerBypassingCache;
}

- (NSString *)URLStringWithPath:(NSString *)path baseURL:(NSURL *)baseURL
{
  AssertTrueOrReturnNil(path.length);
  AssertTrueOrReturnNil(baseURL);
  
  return [[NSURL URLWithString:path relativeToURL:baseURL] absoluteString];
}

- (void)addHttpHeadersFromDictionary:(NSDictionary *)httpHeaders toMutableRequest:(NSMutableURLRequest *)mutableRequest
{
  AssertTrueOrReturn(httpHeaders.count);
  AssertTrueOrReturn(mutableRequest);
  
  [httpHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
    NSString *value = httpHeaders[key];
    [mutableRequest addValue:value forHTTPHeaderField:key];
  }];
}

#pragma mark - Lazy initialization

- (AFHTTPRequestOperationManager *)requestOperationManager
{
  NSURL *url = [NSURL URLWithString:(NSString *)kServerBaseURL];
  
  if (!_requestOperationManager) {
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    _requestOperationManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  }
  return _requestOperationManager;
}

@end
