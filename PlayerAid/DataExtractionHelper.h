//
//  PlayerAid
//

#import <FacebookSDK/FacebookSDK.h>

@interface DataExtractionHelper : NSObject

+ (NSString *)emailFromFBGraphUser:(id<FBGraphUser>)user;

@end
