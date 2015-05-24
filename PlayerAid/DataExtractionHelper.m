//
//  PlayerAid
//

#import "DataExtractionHelper.h"


@implementation DataExtractionHelper

+ (NSString *)emailFromFBGraphUser:(id<FBGraphUser>)user
{
  NSString *email = [user objectForKey:@"email"];
  
  // it is possible to have a user without registered email address, but we always want to have one, thus creating one from username if necessary
  if (!email.length) {
    NSString *name = [self nameWithoutSpacesFromFBGraphUser:user];
    email = [NSString stringWithFormat:@"%@@facebook.com", name];
  }
  return email;
}

+ (NSString *)nameWithoutSpacesFromFBGraphUser:(id<FBGraphUser>)user
{
  NSString *name = [self nameFromFBGraphUser:user];
  name = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  return name;
}

+ (NSString *)nameFromFBGraphUser:(id<FBGraphUser>)user
{
  NSString *name = user.username;
  if (!name.length) {
    name = [user objectForKey:@"name"];
  }
  AssertTrueOrReturnNil(name.length);
  return [name tw_stringByTrimmingWhitespaceAndNewline];
}

@end
