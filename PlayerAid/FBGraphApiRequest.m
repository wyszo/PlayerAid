//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
@import FBSDKCoreKit;
#import "FBGraphApiRequest.h"

static const NSTimeInterval kGraphApiConnectionTimeout = 30.0;

static NSString *const kUserIDDictionaryKey = @"id";
static NSString *const kFirstNameDictionaryKey = @"first_name";
static NSString *const kMiddleNameDictionaryKey = @"middle_name";
static NSString *const kLastNameDictionaryKey = @"last_name";
static NSString *const kNameDictionaryKey = @"name";
static NSString *const kLinkDictionaryKey = @"link";
static NSString *const kEmailDictionaryKey = @"email";

static NSString *const kProfileGraphApiPath = @"me";

@interface FBGraphApiRequest ()
@property (nonatomic, strong) FBSDKGraphRequest *request;
@end

@implementation FBGraphApiRequest

#pragma mark - interface

- (void)makeGraphApiProfileRequestWithCompletion:(ProfileRequestCompletionBlock)completionBlock
{
  [self configureGraphApiConnectionTimeout];
  
  NSString *fields = self.profileGraphApiRequestFieldsString;
  AssertTrueOrReturn(fields);
  NSDictionary *parameters = @{ @"fields" : fields };
  
  self.request = [[FBSDKGraphRequest alloc] initWithGraphPath:kProfileGraphApiPath parameters:parameters];
  [self.request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if (error) {
      CallBlock(completionBlock, nil, nil, error);
    }
    else {
      AssertTrueOrReturn([result isKindOfClass:[NSDictionary class]]);
      NSDictionary *userDictionary = (NSDictionary *)result;
      
      FBSDKProfile *profile = [self fbSdkProfileFromDictionary:userDictionary];
      NSString *email = userDictionary[kEmailDictionaryKey];
      
      CallBlock(completionBlock, profile, email, nil);
    }
  }];
}

#pragma mark - private

- (void)configureGraphApiConnectionTimeout
{
  [FBSDKGraphRequestConnection setDefaultConnectionTimeout:kGraphApiConnectionTimeout];
}

- (NSString *)profileGraphApiRequestFieldsString
{
  NSArray *parameters = @[ kUserIDDictionaryKey, kEmailDictionaryKey, kFirstNameDictionaryKey, kMiddleNameDictionaryKey, kLastNameDictionaryKey, kNameDictionaryKey, kLinkDictionaryKey ];
  NSString *fields = [[parameters valueForKey:@"description"] componentsJoinedByString:@", "];
  AssertTrueOrReturnNil(fields.length);
  return fields;
}

#pragma mark - FBSDKProfile factory

- (FBSDKProfile *)fbSdkProfileFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary.count);
  
  NSString *userID = dictionary[kUserIDDictionaryKey];
  NSString *firstName = dictionary[kFirstNameDictionaryKey];
  NSString *middleName = dictionary[kMiddleNameDictionaryKey];
  NSString *lastName = dictionary[kLastNameDictionaryKey];
  NSString *name = dictionary[kNameDictionaryKey];
  
  NSString *linkString = dictionary[kLinkDictionaryKey];
  NSURL *link = [NSURL URLWithString:linkString];

  FBSDKProfile *profile = [[FBSDKProfile alloc] initWithUserID:userID firstName:firstName middleName:middleName lastName:lastName name:name linkURL:link refreshDate:nil];
  AssertTrueOrReturnNil(profile);
  return profile;
}

@end
