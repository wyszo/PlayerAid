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
