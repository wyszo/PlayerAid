//
//  PlayerAid
//

@import KZAsserts;
#import "EnvironmentSettings.h"

static NSString const* kAppStoreEnvName = @"playeraid";
static NSString const* kProductionEnvName = @"production";
static NSString const* kQAEnvName = @"qa";
static NSString const* kStagingEnvName = @"staging";

static NSString const* kProductionServerBaseURL = @"http://api.playeraid.co.uk/v1/";
static NSString const* kQAServerBaseURL = @"http://qa.api.playeraid.co.uk/v1/";
static NSString const* kStagingServerBaseURL = @"https://staging-2.api.playeraid.co.uk/v1/";


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

- (nullable NSString *)serverRSACertificatePath
{
  NSString *environment = [self appBundleEnvironmentPath];
  AssertTrueOrReturnNil(environment.length);
  
  NSString *certificateName = [NSString stringWithFormat:@"%@.cert.der", environment];
  NSString *certificatePath = [[NSBundle mainBundle] pathForResource:certificateName ofType:nil];
  
  AssertTrueOrReturnNil(certificatePath.length);
  return certificatePath;
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
