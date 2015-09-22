//
//  PlayerAid
//

#import <KZAsserts/KZAsserts.h>
#import "EnvironmentSettings.h"

static NSString const* kAppStoreEnvName = @"playeraid";
static NSString const* kProductionEnvName = @"production";
static NSString const* kQAEnvName = @"qa";
static NSString const* kStagingEnvName = @"staging";

static NSString const* kProductionServerBaseURL = @"http://api.playeraid.co.uk/v1/";
static NSString const* kQAServerBaseURL = @"http://qa.api.playeraid.co.uk/v1/";
static NSString const* kStagingServerBaseURL = @"http://staging.api.playeraid.co.uk/v1/";
static NSString const* kOfficialMockServerBaseURL = @"http://mock.api.playeraid.co.uk/v1/"; // still required?
static NSString const* kMockableIoServerBaseURL = @"http://demo6914797.mockable.io/v1/"; // still required?
static NSString const* kDemoServerBaseURL = @"http://playeraid-api-demo.azurewebsites.net/v1/"; // still required?

static NSString const *kTestRSAPublicKey = @"-----BEGIN PUBLIC KEY-----\n"
  "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD20hUcJwcVeFVnSQZPCYBF+0F2\n"
  "MnsS6wUNwLr/DW2SYNxer2BK+c6yFFQ7rmvMqpPyqRoQli/fOZW/8aoInt4KRpQ9\n"
  "DTuKGVQSb3xhYHEjRe1muzlH/osQC/kmStNV6PlMt9XO5tdif7XvAntUDK00nZTk\n"
  "KUk1b4aS3XJr4g7e7wIDAQAB\n"
  "-----END PUBLIC KEY-----";

static NSString const *kTest4096BitRSAPublicKey = @"-----BEGIN PUBLIC KEY-----\n"
  "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwPPzkw+NygQ3cDGwLJwL\n"
  "G6CCQLFzBFMMSViXE4VOHmtUJJF1tddnSwHk+F9w3sWSUNWCt8r0YriGUfxDgI6o\n"
  "Y6EFs/2KPlQda/7fYCZCWtEpZE1OcKjmoQClBVaYI6XNSdrb+epb4QxHoCsuf6gI\n"
  "hcA7ZbzecF8ezRVQImssRH5zsVFTd4JzhCmBp6TSn6NruC0GsGXve7430J54Y0Fe\n"
  "3EwWmrDK3IscbyjYFUOVh2ldYuM4xgMD0UWpYMKx4pJTKJ58oJpOk9jXf6cnFJKe\n"
  "O9Ichh8POZ0wDtO2yGAH0BXZbF/eZ2BGLWwqgv3nS/gS3g8wASYeiGXdfUmjF1Ku\n"
  "wV+G6++B/5cCa0lM2J79QtOM5rocYOJ5Or5hJZTbrOkQOQuj5SEroAj1spLUsjpD\n"
  "KCL4h/AqbUnnWJXqJxKcHC8LlkHfqu/3XYkgEuhyclm+SRJVFnbyrkRoC3eIfAxJ\n"
  "FAad5pkiiQUyNbi5uiD7HwJu/kk7/X62oGI0T+gesNezeeJ6M2ZHekyHfw3j5b+x\n"
  "nwWEFreVvmUnhxzxY1JQ4xEzRIAkyegFJEh9dEmQUXIWzpy8sTmL8kbL6IK9X+QW\n"
  "iYKcXTotWPenoJUViEftAoaeN0nd5OjYmmD55KaOjcZa5nmKQYMQc/NAjdEC+p2Y\n"
  "+8PxnUfBLBwdTR5ed03dyZ8CAwEAAQ==\n"
  "-----END PUBLIC KEY-----";

@implementation EnvironmentSettings

#pragma mark - Server URL

- (NSString *)serverBaseURL
{
  NSDictionary *bundleToEnvironmentMapping = [self bundleToEnvironmentMapping];
  
  NSString *environment = [self appBundleEnvironmentPath];
  AssertTrueOrReturnNil(environment.length);
  
  NSString *serverPath = bundleToEnvironmentMapping[environment];
  AssertTrueOrReturnNil(serverPath);
  
  return serverPath;
}

- (NSDictionary *)bundleToEnvironmentMapping
{
  return @{
           kAppStoreEnvName : kProductionServerBaseURL,
           kProductionEnvName : kProductionServerBaseURL,
           kQAEnvName : kQAServerBaseURL,
           kStagingEnvName : kStagingServerBaseURL,
           };
}

#pragma mark - RSA keys

- (NSString *)serverRSAPublicKey
{
  NSString *environment = [self appBundleEnvironmentPath];
  AssertTrueOrReturnNil(environment.length);
  
  NSString *rsaKey = self.bundleToRSAKeyMapping[environment];
  AssertTrueOrReturnNil(rsaKey.length);
  
  return rsaKey;
}

- (NSDictionary *)bundleToRSAKeyMapping
{
  return @{
           kStagingEnvName : kTestRSAPublicKey,
           // kStagingEnvName  : kTest4096BitRSAPublicKey,
           // TODO: bundle our Server public keys here...
          };
}

#pragma mark - BundleID

- (NSString *)appBundleEnvironmentPath
{
  NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSArray *bundleComponents = [bundleID componentsSeparatedByString:@"."];
  NSString *bundleServerPath = [bundleComponents lastObject];
  AssertTrueOrReturnNil(bundleServerPath.length);
  return bundleServerPath;
}

@end
