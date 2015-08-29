//
//  PlayerAid
//

#import <AFNetworking.h>
#import <TWCommonLib/TWCommonMacros.h>
#import "UnauthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"
#import "NSURL+URLString.h"


@implementation AuthenticationRequestData
@end


@interface UnauthenticatedServerCommunicationController()
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@end


@implementation UnauthenticatedServerCommunicationController

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

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
  
  NSDictionary *httpHeaders = @{  @"X-Provider" : @"Facebook"  };
  
  [self postAuthWithParameters:parameters customHTTPHeaders:httpHeaders success:^(AFHTTPRequestOperation *operation, id responseObject) {
    CallBlock(completion, operation.response, responseObject, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, nil, nil, error);
  }];
}

- (void)requestAPITokenWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable void (^)( NSString * __nullable apiToken,  NSError * __nullable error))completion
{
  // TODO: password should be RSA encrypted!!
  NSString *credentials = [NSString stringWithFormat:@"%@:%@", email, password];
  credentials = [credentials tw_base64EncodedString];
  
  NSString *authorizationString = [NSString stringWithFormat:@"Basic %@", credentials];
  NSDictionary *httpHeaders = @{  @"Authorization" : authorizationString  };
  
  [self postAuthWithParameters:nil customHTTPHeaders:httpHeaders success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *apiToken = @""; // TODO: obtain API token from the responseObject!!
    NOT_IMPLEMENTED_YET_RETURN
    
    CallBlock(completion, apiToken, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, nil, error);
  }];
}

#pragma mark - Auxiliary methods

- (void)postAuthWithParameters:(nullable NSDictionary *)parameters customHTTPHeaders:(nullable NSDictionary *)httpHeaders success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
  AFHTTPRequestOperationManager *operationManagerNoCache = [self requestOperationManagerBypassignCache];
  
  NSString *URLString = [NSURL URLStringWithPath:@"auth" baseURL:operationManagerNoCache.baseURL];
  
  NSMutableURLRequest *request = [operationManagerNoCache.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
  AssertTrueOrReturn(request);
  [request addHttpHeadersFromDictionary:httpHeaders];
  
  AFHTTPRequestOperation *operation = [operationManagerNoCache HTTPRequestOperationWithRequest:request success:successBlock failure:failureBlock];
  [operationManagerNoCache.operationQueue addOperation:operation];
}

- (AFHTTPRequestOperationManager *)requestOperationManagerBypassignCache
{
  AFHTTPRequestOperationManager *requestOperationManagerBypassingCache = self.requestOperationManager;
  requestOperationManagerBypassingCache.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  AssertTrueOrReturnNil(requestOperationManagerBypassingCache);
  return requestOperationManagerBypassingCache;
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
