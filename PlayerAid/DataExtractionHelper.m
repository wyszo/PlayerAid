//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "DataExtractionHelper.h"

@implementation DataExtractionHelper

+ (NSString *)emailFromFBGraphUser:(FBSDKProfile *)user
{
  AssertTrueOrReturnNil(user);
  
  // TODO: migrate email to new SDK 4.x. Email is no longer part of the user object!
  NSString *email = nil; // [user objectForKey:@"email"];
  
  // it is possible to have a user without registered email address, but we always want to have one, thus creating one from username if necessary
  if (!email.length) {
    NSString *name = [self nameWithoutSpacesFromFBGraphUser:user];
    email = [NSString stringWithFormat:@"%@@facebook.com", name];
  }
  return email;
}

+ (NSString *)nameWithoutSpacesFromFBGraphUser:(FBSDKProfile *)user
{
  AssertTrueOrReturnNil(user);
  NSString *name = [self nameFromFBGraphUser:user];
  name = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  return name;
}

+ (NSString *)nameFromFBGraphUser:(FBSDKProfile *)user
{
  NSString *name = user.name;
  AssertTrueOrReturnNil(name.length);
  return [name tw_stringByTrimmingWhitespaceAndNewline];
}

@end
