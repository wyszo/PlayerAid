//
//  PlayerAid
//

#import "DataExtractionHelper.h"


@implementation DataExtractionHelper

+ (NSString *)emailFromFBGraphUser:(id<FBGraphUser>)user
{
  // it is possible to have a user without registered email address, but we always want to have one
  NSString *email = [user objectForKey:@"email"];
  return (email ? email : [NSString stringWithFormat:@"%@@facebook.com", user.username]);
}

@end
