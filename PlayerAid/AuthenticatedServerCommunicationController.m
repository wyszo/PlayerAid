//
//  PlayerAid
//

#import <AFNetworking.h>
#import "AuthenticatedServerCommunicationController.h"
#import "GlobalSettings.h"
#import "Section.h"
#import "TutorialStep.h"
#import "NSURL+URLString.h"
#import "EnvironmentSettings.h"


static NSString *const kTutorialUrlString = @"tutorial";
static NSString *const kUserUrlString = @"user";
static NSString *const kListTutorialsUrlString = @"tutorials";


@interface AuthenticatedServerCommunicationController ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, strong) NSString *apiToken;
@end


@implementation AuthenticatedServerCommunicationController

/* Technical debt: could easily avoid making a singleton here */
SHARED_INSTANCE_GENERATE_IMPLEMENTATION


+ (void)setApiToken:(NSString *)apiToken
{
  AssertTrueOrReturn(apiToken.length);
  ((AuthenticatedServerCommunicationController *)[self sharedInstance]).apiToken = apiToken;
}

#pragma mark - Ping

- (void)pingCompletion:(NetworkResponseBlock)completion
{
  [self performGetRequestWithApiToken:self.apiToken urlString:@"ping" useCacheIfAllowed:NO completion:completion];
}

#pragma mark - Users management

- (void)getCurrentUserCompletion:(NetworkResponseBlock)completion
{
  [self performGetRequestWithApiToken:self.apiToken urlString:@"user" useCacheIfAllowed:YES completion:completion];
}

- (void)getUserWithID:(NSString *)userID completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(userID.length);
  NSString *urlString = [@"user/" stringByAppendingString:userID];
  [self performGetRequestWithApiToken:self.apiToken urlString:urlString useCacheIfAllowed:YES completion:completion];
}

#pragma mark - Tutorial management

- (void)listTutorialsWithCompletion:(NetworkResponseBlock)completion
{
  [self performGetRequestWithApiToken:self.apiToken urlString:kListTutorialsUrlString useCacheIfAllowed:YES completion:completion];
}

- (void)deleteTutorial:(Tutorial *)tutorial completion:(void (^)(NSError *error))completion
{
  AssertTrueOrReturn(tutorial.serverID);
  NSString *URLString = [self urlStringForTutorialID:tutorial.serverID];
  
  [self.requestOperationManager DELETE:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    CallBlock(completion, nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, error);
  }];
}

- (NSString *)urlStringForTutorialID:(NSNumber *)tutorialID
{
  return [self urlStringForTutorialIDString:tutorialID.stringValue];
}

- (NSString *)urlStringForTutorialIDString:(NSString *)tutorialID
{
  AssertTrueOrReturnNil(tutorialID.length);
  return [NSString stringWithFormat:@"%@/%@", kTutorialUrlString, tutorialID];
}

- (void)createTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(tutorial.title.length);
  AssertTrueOrReturn(tutorial.section.name);
  
  NSDictionary *parameters = @{
                               @"title" : tutorial.title,
                               @"section" : tutorial.section.name,
                               // Optionally we could send CreatedOn date here
                              };
  
  [self performPostRequestWithApiToken:self.apiToken urlString:kTutorialUrlString parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    CallBlock(completion, response, responseObject, error);
  }];
}

- (void)submitImageForTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion;
{
  AssertTrueOrReturn(tutorial);
  AssertTrueOrReturn(tutorial.pngImageData);
  NSString *tutorialID = [tutorial.serverID stringValue];
  AssertTrueOrReturn(tutorialID);
  
  AFHTTPRequestOperationManager *operationManager = [self operationManageWithApiToken:self.apiToken useCacheIfAllowed:NO];
  
  NSString *URLString = [NSString stringWithFormat:@"%@/image", [self urlStringForTutorialIDString:tutorialID]];
  URLString = [NSURL URLStringWithPath:URLString baseURL:operationManager.baseURL];
  
  [self postMultipartFormDataWithURLString:URLString position:nil mainContentName:@"image" fileData:tutorial.pngImageData mimeType:@"image/png" appendToFormDataWithBlock:nil completionBlock:completion];
}

- (void)submitTutorialStep:(TutorialStep *)tutorialStep withPosition:(NSInteger)position completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(tutorialStep);
  
  if ([tutorialStep isTextStep]) {
    [self submitTextTutorialStep:tutorialStep withPosition:position completion:completion];
  }
  else if ([tutorialStep isImageStep]) {
    [self submitImageTutorialStep:tutorialStep withPosition:position completion:completion];
  }
  else if ([tutorialStep isVideoStep]) {
    [self submitVideoTutorialStep:tutorialStep withPosition:position completion:completion];
  }
  else {
    AssertTrueOrReturn(false); // NOT IMPLEMENTED YET
  }
}

- (NSString *)URLStringForTutorialStep:(TutorialStep *)tutorialStep
{
  AssertTrueOrReturnNil(tutorialStep);
  NSNumber *serverID = tutorialStep.belongsTo.serverID;
  AssertTrueOrReturnNil(serverID);
  return [NSString stringWithFormat:@"%@/step", [self urlStringForTutorialID:serverID]];
}

- (void)submitTextTutorialStep:(TutorialStep *)tutorialStep withPosition:(NSInteger)position completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn([tutorialStep isTextStep]);
  
  NSString *URLString = [self URLStringForTutorialStep:tutorialStep];
  NSDictionary *parameters = @{
                               @"position" : @(position),
                               @"value" : tutorialStep.text
                              };
  [self performPostRequestWithApiToken:self.apiToken urlString:URLString parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    CallBlock(completion, response, responseObject, error);
  }];
}

- (void)submitImageTutorialStep:(TutorialStep *)tutorialStep withPosition:(NSInteger)position completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn([tutorialStep isImageStep]);
  
  NSString *URLString = [self URLStringForTutorialStep:tutorialStep];
  [self postMultipartFormDataWithURLString:URLString position:@(position) mainContentName:@"image" fileData:tutorialStep.imageData mimeType:@"image/png" appendToFormDataWithBlock:nil completionBlock:completion];
}

- (void)submitVideoTutorialStep:(TutorialStep *)tutorialStep withPosition:(NSInteger)position completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn([tutorialStep isVideoStep]);
  AssertTrueOrReturn(tutorialStep.videoPath);
  
  NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tutorialStep.videoPath]];
  AssertTrueOrReturn(videoData);
  
  void (^appendThumbnailBlock)(id<AFMultipartFormData>) = ^(id<AFMultipartFormData> formData) {
    NSData *thumbnailImageData = UIImagePNGRepresentation(tutorialStep.thumbnailImage);
    AssertTrueOrReturn(thumbnailImageData);
    [formData appendPartWithFileData:thumbnailImageData name:@"thumbnail" fileName:@"videoThumbnail" mimeType:@"image/png"];
  };
  
  NSString *URLString = [self URLStringForTutorialStep:tutorialStep];
  [self postMultipartFormDataWithURLString:URLString position:@(position) mainContentName:@"video" fileData:videoData mimeType:@"video/mp4" appendToFormDataWithBlock:appendThumbnailBlock completionBlock:completion];
}

- (void)postMultipartFormDataWithURLString:(NSString *)URLString position:(NSNumber *)position mainContentName:(NSString *)name fileData:(NSData *)data mimeType:(NSString *)mimetype appendToFormDataWithBlock:(void (^)(id<AFMultipartFormData>))appendToFormDataBlock completionBlock:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(URLString);
  AssertTrueOrReturn(data);
  AssertTrueOrReturn(name);
  AssertTrueOrReturn(mimetype.length);
  
  AFHTTPRequestOperationManager *operationManager = [self operationManageWithApiToken:self.apiToken useCacheIfAllowed:NO];
  
  [operationManager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    if (position) {
      NSData *positionData = [[position stringValue] dataUsingEncoding:NSUTF8StringEncoding];
      AssertTrueOr(positionData, ;);
      [formData appendPartWithFormData:positionData name:@"position"];
    }
    [formData appendPartWithFileData:data name:name fileName:@"" mimeType:mimetype];
    CallBlock(appendToFormDataBlock, formData);
    
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    CallBlock(completion, nil, responseObject, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    CallBlock(completion, nil, nil, error);
  }];
}

- (void)submitTutorialForReview:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(tutorial);
  
  NSDictionary *parameters = @{
                               @"id" : tutorial.serverID.stringValue
                              };
  NSString *URLString = [[self urlStringForTutorialID:tutorial.serverID] stringByAppendingString:@"/review"];
  [self performPostRequestWithApiToken:self.apiToken urlString:URLString parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    CallBlock(completion, response, responseObject, error);
  }];
}

- (void)likeTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion
{
  NSString *urlString = [self likeUrlStringForTutorial:tutorial];
  [self performPostRequestWithApiToken:self.apiToken urlString:urlString parameters:nil completion:completion];
}

- (void)unlikeTutorial:(Tutorial *)tutorial completion:(NetworkResponseBlock)completion
{
  NSString *urlString = [self likeUrlStringForTutorial:tutorial];
  [self performRequestWithType:@"DELETE" apiToken:self.apiToken urlString:urlString parameters:nil useCacheIfAllowed:NO completion:completion];
}

- (NSString *)likeUrlStringForTutorial:(Tutorial *)tutorial
{
  AssertTrueOrReturnNil(tutorial);
  return [[self urlStringForTutorialID:tutorial.serverID] stringByAppendingString:@"/like"];
}

#pragma mark - Edit profile

- (void)updateUserAvatarFromFacebookWithAccessToken:(NSString *)facebookToken completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(facebookToken.length);
  NSDictionary *parameters = @{
                               @"source" : @"Facebook",
                               @"token" : facebookToken
                              };
  
  [self performPostRequestWithApiToken:self.apiToken urlString:@"user/picture" parameters:parameters completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    CallBlock(completion, response, responseObject, error);
  }];
}

- (void)saveUserProfileWithName:(NSString *)userName description:(NSString *)userDescription completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(userName.length);
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{ @"name" : userName }];
  if (userDescription.length) {
    [parameters addEntriesFromDictionary:@{ @"description" : userDescription }];
  }
  [self performRequestWithType:@"PUT" apiToken:self.apiToken urlString:@"user" parameters:parameters useCacheIfAllowed:NO completion:completion];
}

- (void)saveUserAvatarPicture:(UIImage *)image completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(image);
  NSData *imageData = UIImagePNGRepresentation(image);
  AssertTrueOrReturn(imageData);
  
  AFHTTPRequestOperationManager *operationManager = [self operationManageWithApiToken:self.apiToken useCacheIfAllowed:NO];
  NSString *URLString = [NSURL URLStringWithPath:@"user/picture" baseURL:operationManager.baseURL];
  
  [self postMultipartFormDataWithURLString:URLString position:nil mainContentName:@"image" fileData:imageData mimeType:@"image/png" appendToFormDataWithBlock:nil completionBlock:completion];
}

#pragma mark - Sending requests

- (void)performGetRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  [self performRequestWithType:@"GET" apiToken:apiToken urlString:urlString parameters:nil useCacheIfAllowed:useCache completion:completion];
}

- (void)performPostRequestWithApiToken:(NSString *)apiToken urlString:(NSString *)urlString parameters:(id)parameters completion:(NetworkResponseBlock)completion
{
  [self performRequestWithType:@"POST" apiToken:apiToken urlString:urlString parameters:parameters useCacheIfAllowed:NO completion:completion];
}

- (void)performRequestWithType:(NSString *)requestType apiToken:(NSString *)apiToken urlString:(NSString *)urlString parameters:(id)parameters useCacheIfAllowed:(BOOL)useCache completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(requestType.length);
  AssertTrueOrReturn(urlString.length);
  AssertTrueOrReturn(completion);
  
  AFHTTPRequestOperationManager *operationManager = [self operationManageWithApiToken:apiToken useCacheIfAllowed:useCache];

  NSString *selectorString = [requestType stringByAppendingString:@":parameters:success:failure:"];
  SEL selector = NSSelectorFromString(selectorString);
  AssertTrueOrReturn([operationManager respondsToSelector:selector]);
  
  [self invokeAFNetworkingOperationWithReuqestWithSelector:selector operationManager:operationManager urlString:urlString parameters:(id)parameters successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
      CallBlock(completion, operation.response, responseObject, nil);
  } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
      CallBlock(completion, operation.response, nil, error);
  }];
}

- (void)invokeAFNetworkingOperationWithReuqestWithSelector:(SEL)selector operationManager:(AFHTTPRequestOperationManager *)operationManager urlString:(NSString *)urlString parameters:(id)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
  /**
   Technical debt: this method implementation could be simplified by using the following method instead:
   - (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
   */
  
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

#pragma mark - Users

- (void)followUser:(User *)user completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(user);
  NSString *urlString = [[self urlStringForUser:user] stringByAppendingString:@"/follow"];
  [self performRequestWithType:@"POST" apiToken:self.apiToken urlString:urlString parameters:nil useCacheIfAllowed:NO completion:completion];
}

- (void)unfollowUser:(User *)user completion:(NetworkResponseBlock)completion
{
  AssertTrueOrReturn(user);
  NSString *urlString = [[self urlStringForUser:user] stringByAppendingString:@"/follow"];
  [self performRequestWithType:@"DELETE" apiToken:self.apiToken urlString:urlString parameters:nil useCacheIfAllowed:NO completion:completion];
}

- (NSString *)urlStringForUser:(User *)user
{
  AssertTrueOrReturnNil(user);
  NSString *userID = [user.serverID stringValue];
  return [NSString stringWithFormat:@"%@/%@", kUserUrlString, userID];
}

#pragma mark - Lazy initialization

- (AFHTTPRequestOperationManager *)requestOperationManager
{
  NSString *serverURL = [[EnvironmentSettings new] serverBaseURL];
  AssertTrueOrReturnNil(serverURL.length);
  
  NSURL *url = [NSURL URLWithString:serverURL];
  
  if (!_requestOperationManager) {
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    _requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
  }
  _requestOperationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy; // reset to default cache
  return _requestOperationManager;
}

@end
