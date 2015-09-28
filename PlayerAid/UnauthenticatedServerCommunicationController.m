//
//  PlayerAid
//

#import <AFNetworking/AFNetworking.h>
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/NSString+TWBase64Encoding.h>
#import "UnauthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"
#import "NSURL+URLString.h"
#import "EnvironmentSettings.h"
#import "RSAEncoder.h"
#import "DebugSettings.h"
#import "NSError+PlayerAidErrors.h"
#import "LoginManager.h"

static NSString *const kAuthPath = @"auth";
static NSString *const kUserPath = @"user";


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
  
  [self postPath:kAuthPath parameters:parameters customHTTPHeaders:httpHeaders success:^(AFHTTPRequestOperation *operation, id responseObject) {
    CallBlock(completion, operation.response, responseObject, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, nil, nil, error);
  }];
}

- (void)loginWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable void (^)( NSString * __nullable apiToken,  NSError * __nullable error))completion
{
  AssertTrueOrReturn(email.length);
  AssertTrueOrReturn(password.length);
  
  void (^FailureCompletionBlock)() = ^() {
    NSInteger errorCode = 10;
    NSError *error = [NSError errorWithDomain:@"RSAEncoding" code:errorCode userInfo:nil];
    CallBlock(completion, nil, error);
  };
  
  NSString *credentials = [NSString stringWithFormat:@"%@:%@", email, password];
  
  credentials = [[RSAEncoder new] encodeString:credentials];
  AssertTrueOr(credentials, FailureCompletionBlock(); return;);
  
  NSString *authorizationString = [NSString stringWithFormat:@"Basic %@", credentials];
  NSDictionary *httpHeaders = @{  @"Authorization" : authorizationString  };
  
  [self postPath:kAuthPath parameters:nil customHTTPHeaders:httpHeaders success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSString *apiToken = [self apiTokenFromResponseObject:responseObject errorRef:&error];
    CallBlock(completion, apiToken, error);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, nil, error);
  }];
}

- (void)signUpWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable ApiTokenRequestCompletion)completion
{
  AssertTrueOrReturn(email.length);
  AssertTrueOrReturn(password.length);
  
  void (^FailureCompletionBlock)() = ^(){
    NSInteger errorCode = 11;
    NSError *error = [NSError errorWithDomain:@"DataCorruption" code:errorCode userInfo:nil];
    CallBlock(completion, nil, error);
  };
  
  RSAEncoder *rsaEncoder = [RSAEncoder new];
  NSString *credentials = [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}", email, password];
  
  NSData *rsaEncodedData = [rsaEncoder encodeString:credentials];
  AssertTrueOr(rsaEncodedData.length, FailureCompletionBlock(); return;);
  
  AFHTTPRequestOperationManager *operationManagerNoCache = [self requestOperationManagerBypassignCache];
  
  NSString *serverURLString = [[EnvironmentSettings new] serverBaseURL];
  NSURL *url = [NSURL URLWithPath:kUserPath baseURL:[NSURL URLWithString:serverURLString]];
  AssertTrueOrReturn(url);
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];
  
  NSDictionary *httpHeaders = @{ @"X-Authenticate" : @"true", @"Content-type" : @"application/json", @"Accept" : @"application/json"};
  
  [request addHttpHeadersFromDictionary:httpHeaders];
  [request setHTTPBody:rsaEncodedData];
  
  AFHTTPRequestOperation *operation = [operationManagerNoCache HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *error = nil;
    NSString *apiToken = [self apiTokenFromResponseObject:responseObject errorRef:&error];
    CallBlock(completion, apiToken, error);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, nil, error);
  }];
  
  [operationManagerNoCache.operationQueue addOperation:operation];
}

#pragma mark - Auxiliary methods

- (nullable NSString *)apiTokenFromResponseObject:(nullable id)responseObject errorRef:(NSError **)errorRef
{
  NSDictionary *responseDictionary;
  if ([responseObject isKindOfClass:[NSDictionary class]]) {
    responseDictionary = (NSDictionary *)responseObject;
  }
  
  NSString *apiToken = responseDictionary[@"accessToken"];
  if (!apiToken.length) {
    (*errorRef) = [NSError authenticationTokenError];
  }
  return apiToken;
}

- (void)postPath:(nonnull NSString *)path parameters:(nullable NSDictionary *)parameters customHTTPHeaders:(nullable NSDictionary *)httpHeaders success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
  AssertTrueOrReturn(path.length);
  AFHTTPRequestOperationManager *operationManagerNoCache = [self requestOperationManagerBypassignCache];
  
  NSString *URLString = [NSURL URLStringWithPath:path baseURL:operationManagerNoCache.baseURL];
  
  NSMutableURLRequest *request = [operationManagerNoCache.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
  AssertTrueOrReturn(request);
  if (httpHeaders.count) {
    [request addHttpHeadersFromDictionary:httpHeaders];
  }
  
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
  NSString *serverURL = [[EnvironmentSettings new] serverBaseURL];
  AssertTrueOrReturnNil(serverURL.length);
  
  NSURL *url = [NSURL URLWithString:serverURL];
  
  if (!_requestOperationManager) {
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    _requestOperationManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  }
  return _requestOperationManager;
}

@end
