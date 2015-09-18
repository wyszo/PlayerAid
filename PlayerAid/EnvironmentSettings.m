//
//  PlayerAid
//

#import "EnvironmentSettings.h"

static NSString const* kProductionServerBaseURL = @"http://api.playeraid.co.uk/v1/";
static NSString const* kQAServerBaseURL = @"http://qa.api.playeraid.co.uk/v1/";
static NSString const* kStagingServerBaseURL = @"http://staging.api.playeraid.co.uk/v1/";
static NSString const* kOfficialMockServerBaseURL = @"http://mock.api.playeraid.co.uk/v1/"; // still required?
static NSString const* kMockableIoServerBaseURL = @"http://demo6914797.mockable.io/v1/"; // still required?
static NSString const* kDemoServerBaseURL = @"http://playeraid-api-demo.azurewebsites.net/v1/"; // still required?


@implementation EnvironmentSettings

- (NSString *)serverBaseURL
{
  NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSArray *bundleComponents = [bundleID componentsSeparatedByString:@"."];
  NSString *bundleServerPath = [bundleComponents lastObject];
  NSDictionary *bundleToEnvironmentMapping = [self bundleToEnvironmentMapping];
  
  NSString *serverPath = bundleToEnvironmentMapping[bundleServerPath];
  AssertTrueOrReturnNil(serverPath);
  
  return serverPath;
}

- (NSDictionary *)bundleToEnvironmentMapping
{
  return @{
           @"playeraid" : kProductionServerBaseURL,
           @"production" : kProductionServerBaseURL,
           @"qa" : kQAServerBaseURL,
           @"staging" : kStagingServerBaseURL,
           };
}

@end
