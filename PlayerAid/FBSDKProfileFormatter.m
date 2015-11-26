//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "FBSDKProfileFormatter.h"

@implementation FBSDKProfileFormatter

+ (nullable NSString *)formattedEmail:(nullable NSString *)anEmail fromFBSDKProfile:(nonnull FBSDKProfile *)userProfile
{
  AssertTrueOrReturnNil(userProfile);
  NSString *email = anEmail;
  
  // it is possible to have a user without registered email address, but we always want to have one, thus creating one from username if necessary
  if (!email.length) {
    NSString *name = [self nameWithoutSpacesFromFBSDKProfile:userProfile];
    email = [NSString stringWithFormat:@"%@@facebook.com", name];
  }
  return email;
}

+ (NSString *)nameWithoutSpacesFromFBSDKProfile:(FBSDKProfile *)userProfile
{
  AssertTrueOrReturnNil(userProfile);
  NSString *name = [self nameFromFBSDKProfile:userProfile];
  name = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  return name;
}

+ (NSString *)nameFromFBSDKProfile:(FBSDKProfile *)userProfile
{
  NSString *name = userProfile.name;
  AssertTrueOrReturnNil(name.length);
  return [name tw_stringByTrimmingWhitespaceAndNewline];
}

@end
